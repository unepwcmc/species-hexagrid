module Species
  extend self

  #KEYS = ['scientific_name','common_name','redlist_status','iucn_redlist_url'].freeze
  KEYS = %w(ID_NO HEX_ID binomial common_nam category).freeze
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
end
