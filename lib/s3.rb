class S3
  BASE_PATH = './'.freeze

  def initialize
    @s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])
    @keys = Species.keys
    @species = []
  end

  def get_data(filename, cell_id)
    # Params for connecting to the S3 bucket and querying the given file
    params = {
      bucket: ENV['AWS_BUCKET'],
      key: filename,
      expression_type: 'SQL',
      expression: query(cell_id),
      input_serialization: {
        csv: { file_header_info: 'USE'},
        compression_type: 'GZIP'
      },
      output_serialization: {
        csv: {}
      }
    }.freeze

    # CSV files on S3 are currently zipped in gzip format.
    # The following streams the given file as allows to query the CSV using
    # an SQL-like syntax even if the CSV file is gzipped.
    @s3.select_object_content(params) do |stream|

      # callback for every event that arrives
      stream.on_event do |event|
        # only populate for the situation where we don't have :stats or :end
        # :stats has statistical information about the data transferred such as:
        # => Aws::S3::Types::Stats bytes_scanned=xx, bytes_processed=xx, bytes_returned=xx
        # :end indicates the end of the event
        @species = CSV.parse(event.payload.read).map { |a| Species.new(Hash[@keys.zip(a)]) } if is_records_event?(event)
      end
    end
    Species.merge_realms(@species)
  end

  private

  # Get a subset of values (defined in Species.keys) for each species
  def base_query
    "SELECT #{@keys.join(',')} FROM S3Object"
  end

  # Filter species by category as specified in Species.categories_list
  def query(cell_id)
    "#{base_query} t WHERE t.HEX_ID = '#{cell_id.to_i}' AND t.category IN (#{Species.categories_list})"
  end

  def is_records_event?(event)
    event.event_type == :records
    #![:stats, :end, :cont].include?(event.event_type)
  end
end
