# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :chat

  validates :number, presence: true, uniqueness: { scope: :chat_id }

  before_validation :set_number, on: :create

  private

  def set_number
    self.number ||= self.chat.messages.maximum(:number).to_i + 1
  end
end
