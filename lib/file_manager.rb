module FileManager
  extend self

  GROUP_VAL = 4.freeze
  def calculate_file_index(cell_id)
    cell_id = cell_id.to_i
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
