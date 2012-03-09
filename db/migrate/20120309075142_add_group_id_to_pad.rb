class AddGroupIdToPad < ActiveRecord::Migration
  def change
    add_column :pads, :group_id, :string
    Pad.all.each do |pad|
      group_id, pad_id = pad.pad_id.split "$"
      pad.update_attributes! :group_id => group_id, :pad_id => pad_id
    end
  end
end
