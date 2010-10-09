class CreateNeurons < ActiveRecord::Migration
  def self.up
    create_table :neurons do |t|
      t.string :name
      t.date :date
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :neurons
  end
end
