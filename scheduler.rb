#!clockwork
include Clockwork

handler do |job|
  case job
  when 'update_sp1'
    %x[jets runner "UpdateChannelsJob.perform_now(:sp1)"]
  when 'update_ws1'
    %x[jets runner "UpdateChannelsJob.perform_now(:ws1)"]
  else
    STDERR.puts('Error: Unknown scheduler job.')
  end
end

every(1.minute,  'update_sp1')
every(5.minutes,  'update_ws1')
