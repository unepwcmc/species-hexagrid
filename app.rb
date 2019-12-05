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
  require_relative 's3'
  require_relative 'file_manager'
  require_relative 'species'
  require 'aws-sdk-s3'

  filename = "test_#{params[:id]}.csv"
  @rows = []

  FileManager.with_file(filename) do
    S3.new.get_file(filename)
    S3.new.get_data(filename)
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
