require_relative 'realms'
class Species

  #Order of keys matters
  KEYS = %w(ID_NO HEX_ID binomial category).concat(Realms::REALMS).concat(['common_name']).freeze
  DOWNLOAD_KEYS = {
    'HEX_ID' => 'Hex ID',
    'binomial' => 'Species name',
    'common_name' => 'Common name',
    'category' => 'IUCN Category',
    'realms' => 'Realms',
    'redlist_link' => 'Link to IUCN RedList'
  }.freeze
  IUCN_CATEGORIES = {
    'CR' => 'Critically Endangered',
    'EN' => 'Endangered',
    'VU' => 'Vulnerable',
    'NT' => 'Near Threatened',
    'DD' => 'Data Deficient'
  }.freeze
  THREATENED = %w(CR EN VU).freeze

  # Make KEYS plus :realms accessible instance attributes
  attr_accessor *KEYS.map(&:downcase).map(&:to_sym) << :realms
  def initialize(hash)
    hash.each { |k, v| send("#{k.downcase}=", v) }
  end

  def redlist_link
    "http://apiv3.iucnredlist.org/api/v3/website/#{binomial}"
  end

  def values_for_download
    DOWNLOAD_KEYS.keys.map { |attr| send(attr.downcase) }
  end

  ### CLASS METHODS
  def self.categories_list
    IUCN_CATEGORIES.keys.map { |c| "'#{c}'" }.join(',')
  end

  def self.keys
    KEYS
  end

  def self.merge_realms(species)
    species.each do |s|
      s.realms = Realms.get_realms(s)
    end
    species
  end

  def self.count_by_realm(species)
    counts = {}
    multiple = 0
    _species = species.group_by { |s| s.realms }

    _species.each do |realm, list|
      if realm.include?('/')
        multiple +=  list.count
      else
        counts[realm] = list.count
      end
    end
    counts.tap { |c| c['multiple_realms'] = multiple }
  end

  def self.generate_csv(species)
    CSV.generate do |csv|
      header = DOWNLOAD_KEYS.values
      csv << header

      species.each { |s| csv << s.values_for_download } 
    end
  end
end
