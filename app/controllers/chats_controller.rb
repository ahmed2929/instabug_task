class ChatsController < ApplicationController
  def index
    application = Application.find_by!(token: params[:token])
    if params[:chatId]
      chat = application.chats.find_by!(number: params[:chatId])
      render json: chat
    else
      chats = application.chats
      render json: chats
    end
  end
  def create
    application = Application.find_by(token: params[:token])
    chat = application.chats.build
    if chat.save
      render json: { number: chat.number }, status: :created
    else
      render json: chat.errors, status: :unprocessable_entity
    end
  end
end

# class ChatsController < ApplicationController
#   def create
#     application = Application.find_by(token: params[:token])
#     chat = application.chats.build

#     # Store chat details in Redis
#     redis = Redis.new
#     redis.set("chat:#{chat.id}:#{token}", chat.to_json)

#     # Respond to the user immediately
#     render json: { number: chat.number }, status: :created

#     # Persist chat in MySQL in a background job
#     ChatPersistenceJob.perform_later(chat.id)
#   end
# end
