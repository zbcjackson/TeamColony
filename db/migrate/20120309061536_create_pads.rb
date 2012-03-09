class CreatePads < ActiveRecord::Migration
  def change
    create_table :pads do |t|
      t.string :title
      t.string :pad_id

      t.timestamps
    end
  end
end
