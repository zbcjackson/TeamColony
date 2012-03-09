class AddExistingPad < ActiveRecord::Migration
  def up
    ether = EtherpadLite.connect(:local, File.new(Rails.configuration.pad_api_key_file))
    group = ether.group "team_colony_1"
    ether.client.listPads(group.id) do |pad|
      p = Pad.new :title => EtherpadLite::Pad.degroupify_pad_id(pad.id), :pad_id => pad.id
      p.save
    end
  end

  def down
  end
end
