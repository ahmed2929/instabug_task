class IndexMessageToElasticsearchJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Initialize the Elasticsearch client
    client = Elasticsearch::Client.new log: true

    # Index the message
    client.index index: 'messages',
                 type: 'message',
                 id: message.id,
                 body: {
                   chatId: message.chat.number,
                   applicationId: message.chat.application.id,
                   applicationToken: message.chat.application.token,
                   body: message.body
                 }
  end

end
