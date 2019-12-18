class S3
  BASE_PATH = './'.freeze

  def initialize
    @s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])
    @keys = Species.keys
    @species = []
  end

  def get_file(filename)
    @s3.get_object(*params(filename))
  end

  def get_data(filename, cell_id)
    params = {
      bucket: ENV['AWS_BUCKET'],
      key: filename,
      expression_type: 'SQL',
      expression: "#{query} t WHERE t.HEX_ID = '#{cell_id.to_i}'",
      input_serialization: {
        csv: { file_header_info: 'USE'}#,
        #compression_type: 'GZIP'
      },
      output_serialization: {
        csv: {}
      }
    }.freeze

    @s3.select_object_content(params) do |stream|

      # callback for every event that arrives
      stream.on_event do |event|
        # only populate for the situation where we don't have :stats or :end
        # :stats has statistical information about the data transferred such as:
        # => Aws::S3::Types::Stats bytes_scanned=xx, bytes_processed=xx, bytes_returned=xx
        # :end indicates the end of the event
        @species = CSV.parse(event.payload.read).map {|a| Hash[ @keys.zip(a) ] } if is_records_event?(event)
      end
    end
    @species
  end

  private

  def query
    "SELECT #{Species.keys.join(',')} FROM S3Object"
  end

  def params(filename)
    target = "#{BASE_PATH}#{filename}"
    [{ bucket: ENV['AWS_BUCKET'], key: filename }, {target: target}]
  end

  def is_records_event?(event)
    event.event_type == :records
    #![:stats, :end, :cont].include?(event.event_type)
  end
end
