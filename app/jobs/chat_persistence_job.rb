class ChatPersistenceJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    # Get chat details from Redis
    redis = Redis.new
    chat_json = redis.get("chat:#{chat_id}")
    chat = JSON.parse(chat_json)

    # Persist chat in MySQL
    Chat.create(chat)
  end
end
