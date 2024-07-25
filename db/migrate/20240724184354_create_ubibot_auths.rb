class CreateUbibotAuths < ActiveRecord::Migration[7.1]
  def change
    create_table  :ubibot_auths, id: false do |t|
      t.timestamp :created_at, null: false, default: DateTime.now
      t.timestamp :expired_at, null: false
      t.timestamp :server_time, null: false
      t.string    :token, null: false
    end
    add_index :ubibot_auths, :created_at
    add_index :ubibot_auths, :expired_at
    add_index :ubibot_auths, [:created_at,:expired_at], unique: true
  end
end
