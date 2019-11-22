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

  filename = "test_#{params[:id]}.csv"
  @rows = []

  FileManager.with_file(filename) do
    S3.new.get_file(filename)
    fullname = "#{S3::BASE_PATH}#{filename}"
    CSV.foreach(fullname, headers: true) do |row|
      @rows << row
    end
  end

  erb :species
end

