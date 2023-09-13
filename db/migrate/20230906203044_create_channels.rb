class CreateChannels < ActiveRecord::Migration[6.1]
  def change
    create_table  :channels, id: false do |t|
      t.integer   :id, primary_key: true
      t.string    :name
      t.string    :sensor_type, null: false
      t.string    :location
      t.string    :device_id
      t.string    :product_id
      t.timestamp :last_entry_timestamp
      t.timestamps
    end
    add_index :channels, :sensor_type
    add_index :channels, :device_id, unique: true
  end
end
