class Channel < ApplicationRecord
  validates :sensor_type, presence: true
  has_many :measurements
  def update_channel
    channel_data = channel_data()
    has_data_updates = false
    JSON.parse(channel_data['channel']['last_values']).each do |key, value|
      next unless key.starts_with?('field')

      metric_name = channel_data['channel'][key]
      metric_name = 'Temperature ºC' if channel_data['channel'][key].start_with? 'Temperature'
      next if measurements.find_by(metric: metric_name, created_at: value['created_at'])

      has_data_updates = true
      measurements.create(metric: metric_name, created_at: value['created_at'],
                          value: value['value'].to_f)
      Rails.logger.info "Channel #{id} add [#{value['created_at']}] #{metric_name} = #{value['value'].to_f}"
    end

    if has_data_updates
      self.device_id            = channel_data['channel']['device_id']
      self.name                 = channel_data['channel']['name']
      self.product_id           = channel_data['channel']['product_id']
      self.last_entry_timestamp = channel_data['channel']['last_entry_date']
      save
      Rails.logger.info "Channel #{id} updated."
    else
      Rails.logger.info "No updates for channel #{id}."
    end
  end

  private

  def channel_data
    Rails.logger.info "Querying UbiBot channel #{id}..."
    channel_data_url = "#{Rails.application.config.ubibot_channels_url}/#{id}?token_id=#{UbibotAuth.get_token}"
    ubibot_channel_data_url = URI.parse(channel_data_url)
    response = Faraday.get(ubibot_channel_data_url)
    JSON.parse(response.body) if response.status == 200
  end
end
