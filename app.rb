require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'json'
require 'dotenv/load'

require 'csv'
require 'aws-sdk-resources'
require_relative 'lib/s3'
require_relative 'lib/file_manager'
require_relative 'lib/species'
require 'aws-sdk-s3'

get '/:id' do
  @id = params[:id]
  file_index = FileManager.calculate_file_index(@id)
  filename = "splits_with_attributes/out_#{file_index}.csv.gz"
  @rows = []

  FileManager.with_file(filename) do
    species = S3.new.get_data(filename, @id)
    @realms_counts = Species.count_by_realm(species)
    @total_count = species.count
    @species = species.group_by { |hash| hash['category'] }
    @area = 50
  end

  erb :species
end

get '/:id/download' do
  content_type 'application/csv'
  attachment "myfilename.csv"

  file_index = FileManager.calculate_file_index(params[:id])
  filename = "splits_with_attributes/out_#{file_index}.csv.gz"
  species = S3.new.get_data(filename, params[:id])

  CSV.generate do |csv|
    header = Species::DOWNLOAD_KEYS.values
    csv << header

    species.each do |s|
      _values = s.slice(*Species::DOWNLOAD_KEYS.keys).values
      _link = "http://apiv3.iucnredlist.org/api/v3/website/#{s['binomial']}"
      csv << _values.push(_link)
    end
  end
end