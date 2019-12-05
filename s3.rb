class S3
  BASE_PATH = './'.freeze

  def initialize
    @s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])
  end

  def get_file(filename)
    @s3.get_object(*params(filename))
  end

  def get_data(filename)
    params = {
      bucket: ENV['AWS_BUCKET'],
      key: filename,
      expression_type: 'SQL',
      expression: "SELECT * FROM S3Object WHERE redlist_status = 'CR'",
      input_serialization: {
        csv: { file_header_info: 'USE'}
      },
      output_serialization: {
        csv: {}
      }
    }.freeze

    @s3.select_object_content(params) do |stream|

      # Callback for every event that arrives
      stream.on_event do |event|
         next if event.nil?
         puts event.event_type
         puts event.payload.read unless (event.event_type == :stats || event.event_type == :end)
      end
    end
  end

  private

  def params(filename)
    target = "#{BASE_PATH}#{filename}"
    [{ bucket: ENV['AWS_BUCKET'], key: filename }, {target: target}]
  end
end
