require_relative 'realms'
module Species
  extend self

  #Order of keys matters
  KEYS = %w(ID_NO HEX_ID binomial category).concat(Realms::REALMS).concat(['common_name']).freeze
  IUCN_CATEGORIES = {
    'CR' => 'Critically Endangered',
    'EN' => 'Endangered',
    'VU' => 'Vulnerable',
    'NT' => 'Near Threatened',
    'DD' => 'Data Deficient'
  }.freeze
  THREATENED = %w(CR EN VU).freeze

  def categories_list
    IUCN_CATEGORIES.keys.map { |c| "'#{c}'" }.join(',')
  end

  def keys
    KEYS
  end

  def merge_realms(species)
    species.each do |s|
      s['realms'] = Realms.get_realms(s)
    end
    species
  end

  def count_by_realm(species)
    counts = {}
    multiple = 0
    _species = species.group_by { |s| s['realms'] }

    _species.each do |realm, list|
      if realm.include?('/')
        multiple +=  list.count
      else
        counts[realm] = list.count
      end
    end
    counts.tap { |c| c['multiple_realms'] = multiple }
  end
end
