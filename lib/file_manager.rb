module FileManager
  extend self

  # Constant also used in the script that generates the data CSVs on S3.
  # Change this only if required after discussing it with the data provider
  GROUP_VAL = 4.freeze
  # Get index of the file where data for that cell id is stored.
  # Each file contains data for many cells
  def calculate_file_index(cell_id)
    cell_id = cell_id.to_i
    round_sigfigs(cell_id, cell_id.to_s.length - GROUP_VAL)
  end

  # Round the cell id to get the index of the file where that cell data is contained.
  def round_sigfigs(num, sig_figs)
    if num != 0
      num.round(-(Math.log10(num.abs).floor - (sig_figs - 1)), half: :even)
    else
      0
    end
  end
end
