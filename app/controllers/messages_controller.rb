# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :set_chat, only: [:index]
  def index
    if params[:messageId]
      message = @chat.messages.find_by!(number: params[:messageId])
      render json: message
    else
      messages = @chat.messages
      render json: messages
    end
  end
  def create
    application = Application.find_by(token: params[:token])
    chat = Chat.find_by(number: params[:chatId], application_id: application.id)
    message = chat.messages.build(message_params.merge(application_id: application.id))
    if message.save
      IndexMessageToElasticsearchJob.perform_later(message)
      render json: { number: message.number }, status: :created
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end
  def search
    token = params.require(:token)
    query = params.require(:query)
    chat_id = params.require(:chatId)

    application = Application.find_by!(token: token)

    client = Elasticsearch::Client.new log: true
    results = client.search index: 'messages',
                            body: {
                              query: {
                                bool: {
                                  must: {
                                    match: {
                                      body: query
                                    }
                                  },
                                  filter: [
                                    {
                                      term: {
                                        chatId: chat_id
                                      }
                                    },
                                    {
                                      term: {
                                        applicationId: application.id
                                      }
                                    }
                                  ]
                                }
                              }
                            }
    render json: results['hits']['hits'].map { |hit| hit['_source'].except('applicationToken') }
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  end
  private

  def message_params
    params.require(:message).permit(:body)
  end
  def set_chat
    puts "Token: #{params[:token]}"

    application = Application.find_by(token: params[:token])

    if application
      @chat = Chat.find_by(number: params[:chatId], application_id: application.id)
    else
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
