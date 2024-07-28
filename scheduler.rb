#!clockwork
include Clockwork

handler do |job|
  case job
  when 'cleanup_ubibot_auth'
    %x[rails runner "UbibotAuth::cleanup"]
  when 'update_sp1'
    %x[rails runner "UpdateChannelsJob.perform_now('SP1')"]
  when 'update_ws1'
    %x[rails runner "UpdateChannelsJob.perform_now('WS1')"]
  else
    STDERR.puts('Error: Unknown scheduler job.')
  end
end

every(1.minute,  'update_sp1')
every(5.minutes, 'update_ws1')
every(4.hours,   'cleanup_ubibot_auth')
