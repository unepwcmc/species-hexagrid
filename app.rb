require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'dotenv/load'

get '/' do
  #"Hello world! Version 3. Now with test-suite! </br>"
  erb :index
end

get '/species/:id' do
  require 'csv'
  require 'aws-sdk-resources'
  require 'byebug' # TODO delete this
  require_relative 's3'
  require_relative 'file_manager'
  require_relative 'species'
  require 'aws-sdk-s3'

  filename = "test_#{params[:id]}.csv"
  @rows = []

  client = Aws::S3::Client.new(region: ENV['AWS_REGION'])

  params = {
    bucket: ENV['AWS_BUCKET'],
    key: 'test_3.csv',
    expression_type: 'SQL',
    expression: "SELECT * FROM S3Object WHERE redlist_status = 'CR'",
    input_serialization: {
      csv: { file_header_info: 'USE'}
    },
    output_serialization: {
      csv: {}
    }
  }

  client.select_object_content(params) do |stream|

    # Callback for every event that arrives
    stream.on_event do |event|
       puts event.event_type
       puts event.payload.read unless event.nil?
    end
  end

  FileManager.with_file(filename) do
    S3.new.get_file(filename)
    fullname = "#{S3::BASE_PATH}#{filename}"
    @species = []
    CSV.foreach(fullname, headers: true) do |row|
      @species << row
    end
    @redlist_threatened = Species.order_species(@species)
    @total_count = @species.count
    @species = @species.group_by { |hash| hash['redlist_status'] }
    @area = 50
  end

  erb :species
end
