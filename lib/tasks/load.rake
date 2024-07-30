CSV_FILES_SEARCH_PATH = "#{Rails.root}/.data/*.csv"
JSON_FILES_SEARCH_PATH=".data/json/2024/**/*.json"
THREADS = 10

# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# rake load:csv
# source .env && rake load:json
namespace :load do
  desc 'Import data from CSV files'
  task csv: :environment do
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.info "Load data from CSV files in  #{CSV_FILES_SEARCH_PATH}"
    Parallel.each(Dir[CSV_FILES_SEARCH_PATH], in_processes: 10) do |csv_file|
      start_time = Time.now
      channel_id = File.basename(csv_file).split('-')[0]
      headers = []
      json_docs = {}
      Rails.logger.info "parsing data for channel #{channel_id} from #{csv_file}"
      src_doc = CSV.read(csv_file, headers: true, col_sep: ',')
      src_doc.headers.each { |h| headers << h if h.start_with? 'field' and h[/\(.*?\)/] != '()' }
      src_doc.each do |row|
        created_at = DateTime.parse(row[0])
        day = "#{created_at.strftime('%Y')}-#{created_at.strftime('%m')}-#{created_at.strftime('%d')}"
        headers.each do |header|
          next unless row[header]

          metric = header[/\(.*?\)/].tr('()', '').strip
          measurements = {
            channel_id:,
            created_at:,
            metric:,
            value: row[header]
          }
          json_docs[day] = [] unless json_docs[day]
          json_docs[day] << measurements
        end
      rescue StandardError => e
        Rails.logger.error e.message
      end
      json_docs.each_value do |value|
        Measurement.upsert_all(value)
      end
      finish_time = Time.now
      duration = finish_time - start_time
      Rails.logger.info "#{File.basename(csv_file)} processed in #{duration}"
    end
  end
  desc 'Import data from JSON files'
  task json: :environment do
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.info "Load data from JSON files in  #{JSON_FILES_SEARCH_PATH}"
    json_files = Dir[JSON_FILES_SEARCH_PATH]
    Parallel.each(json_files, in_processes: 10) do |json_file|
      begin
        Measurement.upsert_all(JSON.parse(File.read(json_file)))
        puts "#{File.expand_path(json_file)}".green
      rescue Exception => e
        puts "#{json_file}".red
      end
    end
    Rails.logger.info "total json files: #{json_files.count}"
  end
end