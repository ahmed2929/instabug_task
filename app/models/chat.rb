# app/models/chat.rb
class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :application_id }

  before_validation :set_number, on: :create

  private

  def set_number
    self.number ||= self.application.chats.maximum(:number).to_i + 1
  end
end
