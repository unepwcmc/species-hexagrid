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
  # Get index of CSV file where information for the given cell is contained
  file_index = FileManager.calculate_file_index(@id)
  filename = "splits_with_attributes/out_#{file_index}.csv.gz"
  @rows = []

  # Get data from S3
  species = S3.new.get_data(filename, @id)
  # Count species by realm (biome)
  @realms_counts = Species.count_by_realm(species)
  @total_count = species.count
  # Group species by IUCN category
  @species = species.group_by(&:category)
  @area = 50

  erb :species
end

get '/:id/download' do
  content_type 'application/csv'
  # Name download
  attachment "hexagrid_cell_#{params[:id]}.csv"

  # Get index of CSV file where information for the given cell is contained
  file_index = FileManager.calculate_file_index(params[:id])
  filename = "splits_with_attributes/out_#{file_index}.csv.gz"
  # Get data from S3
  species = S3.new.get_data(filename, params[:id])

  # Generate CSV file download
  Species.generate_csv(species)
end