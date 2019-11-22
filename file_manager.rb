module FileManager
  extend self

  def with_file(filename)
    yield
    destroy(filename)
  end

  def destroy(filename)
    File.delete(filename) if File.exists?(filename)
  end
end
