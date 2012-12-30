class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :sender
      t.string :recipient_email
      t.string :token
      t.datetime :sent_at
      t.references :recipient

      t.timestamps
    end
    add_index :invitations, :sender_id
    add_index :invitations, :recipient_id
  end
end
