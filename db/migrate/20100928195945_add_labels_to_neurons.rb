class AddLabelsToNeurons < ActiveRecord::Migration
  def self.up
    add_column :neurons, :labels, :string
  end

  def self.down
    remove_column :neurons, :labels
  end
end
