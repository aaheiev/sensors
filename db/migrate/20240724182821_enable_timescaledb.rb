class EnableTimescaledb < ActiveRecord::Migration[7.1]
  def up
      enable_extension 'timescaledb'
      execute "SELECT create_hypertable('measurements','created_at')"
  end
  def down
  end
end
