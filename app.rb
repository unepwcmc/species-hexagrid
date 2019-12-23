require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'dotenv/load'

get '/:id' do
  require 'csv'
  require 'aws-sdk-resources'
  require_relative 's3'
  require_relative 'file_manager'
  require_relative 'species'
  require 'aws-sdk-s3'

  file_index = FileManager.calculate_file_index(params[:id])
  filename = "splits_with_attributes\ 2/out_#{file_index}.csv"
  @rows = []

  FileManager.with_file(filename) do
    species = S3.new.get_data(filename, params[:id])
    @total_count = species.count
    @species = species.group_by { |hash| hash['category'] }
    @area = 50
  end

  erb :species
end
