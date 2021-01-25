module Realms
  extend self

  REALMS = %w(biome_marine biome_terrestrial biome_freshwater).freeze

  def realm_names
    REALMS.map { |r| r.split('_').last }
  end

  # Merge realms (biomes) information together for each species.
  # E.g. if species has biome_terrestrial set to true as well as biome_marine,
  # then return 'Terrestrial / Marine' so they are shown together
  # in the same column (Realms).
  def get_realms(s)
    realm_names.map do |r|
      is_true?(s.send("biome_#{r}")) ? r.capitalize : nil
    end.compact.join(' / ')
  end

  # Ensure to capture all possible values that could represent truth.
  TRUE_FLAGS = %w(TRUE True true T t).freeze
  def is_true?(value)
    TRUE_FLAGS.include?(value)
  end

end