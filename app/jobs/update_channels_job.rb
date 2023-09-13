# UpdateChannelsJob.perform_now(:sp1)
# UpdateChannelsJob.perform_now(:ws1)
class UpdateChannelsJob < ApplicationJob

  rate "1 minute" # every 1 minute
  def sp1
    Channel.where("sensor_type = 'SP1'").each {|ch| ch.update_channel}
  end

  rate "5 minutes"
  def ws1
    Channel.where("sensor_type = 'WS1'").each {|ch| ch.update_channel}
  end
end
