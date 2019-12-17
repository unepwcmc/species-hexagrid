module FileManager
  extend self

  def with_file(filename)
    yield
    destroy(filename)
  end

  def destroy(filename)
    File.delete(filename) if File.exists?(filename)
  end

  GROUP_VAL = 4.freeze
  def calculate_file_index(cell_id)
    return round_sigfigs(cell_id, cell_id.to_s.length - GROUP_VAL)
  end

  def round_sigfigs(num, sig_figs)
    if num != 0
      return num.round(-(Math.log10(num.abs).floor - (sig_figs - 1)), half: :even)
    else
      return 0
    end
  end
end
