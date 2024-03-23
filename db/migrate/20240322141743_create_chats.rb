class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.integer :number
      t.references :application, null: false, foreign_key: true
      t.integer :messages_count

      t.timestamps
    end
  end
end

# db/migrate/20220401000000_add_number_to_chats.rb
class AddNumberToChats < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :number, :integer
    add_index :chats, [:application_id, :number], unique: true
  end
end
