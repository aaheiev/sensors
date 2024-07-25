# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
ubibot_channels_file_path = "db/fixtures/ubibot_channels.yaml"

YAML.load(File.read(ubibot_channels_file_path))["ubibot_channels"].each do |key, value|
  channel          = Channel.find_or_create_by(id: key.to_i,sensor_type: value["sensor_type"])
  channel.name     = value["name"]
  channel.location = value["location"] if value["location"]
  channel.save
end
