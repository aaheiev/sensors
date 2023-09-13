class CreateUbibotAuths < ActiveRecord::Migration[6.1]
  def change
    create_table  :ubibot_auths, id: false do |t|
      t.timestamp :created_at, noll: false, default: DateTime.now
      t.timestamp :expired_at, noll: false
      t.timestamp :server_time, noll: false
      t.string    :token_ciphertext, noll: false
    end
    add_index :ubibot_auths, :created_at
    add_index :ubibot_auths, :expired_at
    add_index :ubibot_auths, [:created_at,:expired_at], unique: true
  end
end
