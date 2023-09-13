ubibot_channels_file_path = "db/fixtures/ubibot_channels.yaml"

YAML.load(File.read(ubibot_channels_file_path))["ubibot_channels"].each do |key, value|
  channel = Channel.find_or_create_by(id: key.to_i)
  channel.name        = value["name"]
  channel.sensor_type = value["sensor_type"]
  channel.location    = value["location"] if value["location"]
  # channel.tag_names   = value["tags"].join(",") if value["tags"]
  channel.save
end
