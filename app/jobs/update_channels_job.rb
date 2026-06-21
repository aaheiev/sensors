# UpdateChannelsJob.perform_later('SP1')
# UpdateChannelsJob.perform_later('WS1')
class UpdateChannelsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.info "Update channels with sensor_type: #{args}"
    Channel.where(sensor_type: args).each { |ch| ch.update_channel }
  end
end
