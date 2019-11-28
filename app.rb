require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'dotenv/load'

require 'byebug'

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

  filename = "test_#{params[:id]}.csv"
  @rows = []

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
  end

  erb :species
end
