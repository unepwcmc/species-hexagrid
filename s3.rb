class S3
  BASE_PATH = './'.freeze

  def initialize
    @s3 = Aws::S3::Client.new(region: ENV['AWS_REGION'])
  end

  def get_file(filename)
    @s3.get_object(*params(filename))
  end

  private

  def params(filename)
    target = "#{BASE_PATH}#{filename}"
    [{ bucket: ENV['AWS_BUCKET'], key: filename }, {target: target}]
  end
end
