JSON_FILES_SEARCH_PATH=".fixtures/2023/08/*/*.json"
THREADS = 10
# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# rake load:json
namespace :load do

  desc "Import data from JSON files"
  task :json => :environment do
    # puts "json files count #{Dir[JSON_FILES_SEARCH_PATH].count}"
    Parallel.each(Dir[JSON_FILES_SEARCH_PATH], in_processes: THREADS) do |json_file|
      doc = JSON.parse(File.read(json_file))
      doc.each do |measurement|
        # puts measurement
        unless m = Measurement.find_by(
          channel_id: measurement["channel_id"].to_i,
          created_at: measurement["created_at"],
          metric: measurement["metric"]
        )
          Measurement.create({
                               channel_id: measurement["channel_id"].to_i,
                               created_at: measurement["created_at"],
                               metric: measurement["metric"],
                               value: measurement["value"]
                             })
          puts measurement.to_json
        end
      end
    end
  end
end
