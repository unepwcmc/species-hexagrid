class S3
  BASE_PATH = './'.freeze
  SQL_QUERY = "SELECT * FROM S3Object WHERE redlist_status = 'CR' OR redlist_status = 'EN' OR redlist_status = 'VU'".freeze

  def initialize
    @s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])
    @keys = Species.keys
    @species = []
  end

  def get_file(filename)
    @s3.get_object(*params(filename))
  end

  def get_data(filename)
    params = {
      bucket: ENV['AWS_BUCKET'],
      key: filename,
      expression_type: 'SQL',
      expression: SQL_QUERY,
      input_serialization: {
        csv: { file_header_info: 'USE'}
      },
      output_serialization: {
        csv: {}
      }
    }.freeze

    @s3.select_object_content(params) do |stream|

      # callback for every event that arrives
      stream.on_event do |event|
        # only populate for the situation where we don't have :stats or :end
        @species = CSV.parse(event.payload.read).map {|a| Hash[ @keys.zip(a) ] } unless (event.event_type == :stats || event.event_type == :end)
      end
    end
    @species
  end

  private

  def params(filename)
    target = "#{BASE_PATH}#{filename}"
    [{ bucket: ENV['AWS_BUCKET'], key: filename }, {target: target}]
  end
end
