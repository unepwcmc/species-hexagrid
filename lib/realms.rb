module Realms
  extend self

  REALMS = %w(biome_marine biome_terrestrial biome_freshwater).freeze

  def realm_names
    REALMS.map { |r| r.split('_').last }
  end

  def get_realms(s)
    realm_names.map do |r|
       is_true?(s.send("biome_#{r}")) ? r.capitalize : nil
    end.compact.join(' / ')
  end

  TRUE_FLAGS = %w(TRUE True true T t).freeze
  def is_true?(value)
    TRUE_FLAGS.include?(value)
  end

end