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
    @cr = []
    @en = []
    @vu = []
    CSV.foreach(fullname, headers: true) do |row|
      @rows << row
      @species << row
      if row["redlist_status"] == "CR"
        @cr << row
      elsif row["redlist_status"] == "EN"
        @en << row
      elsif row["redlist_status"] == "VU"
        @vu << row
      end
    end
    @redlist_threatened = Species.order_species(@species)
  end

  erb :species
end
