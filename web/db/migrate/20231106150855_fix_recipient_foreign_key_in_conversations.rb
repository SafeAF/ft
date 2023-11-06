class FixRecipientForeignKeyInConversations < ActiveRecord::Migration[7.0]
  def change
    # First, remove the incorrect foreign key if it exists
    remove_foreign_key :conversations, :recipients, if_exists: true
   # remove_foreign_key :conversations, :senders, if_exists: true

    # Now, add the correct foreign key pointing to the `users` table
    add_foreign_key :conversations, :users, column: :recipient_id
    add_foreign_key :conversations, :users, column: :sender_id
  end
end
