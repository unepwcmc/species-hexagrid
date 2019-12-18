module Species
  extend self

  #KEYS = ['scientific_name','common_name','redlist_status','iucn_redlist_url'].freeze
  KEYS = ['ID_NO', 'HEX_ID', 'binomial', 'common_nam', 'category'].freeze
  THREATENED = %w(CR EN VU).freeze

  def order_species(species)
    # Critically Endangered, Endangered, Vulnerable
    # CR is the most endangered, then comes EN, third VU
    # Fortunately these are alphabetically ordered.s
    species.sort_by! { |hash| hash['category'] }
  end

  def get_threatened(species)
    species.select { |s| THREATENED.include?(s['category'].upcase) }
  end

  def threatened_list
    THREATENED.map { |c| "'#{c}'" }.join(',')
  end

  def keys
    KEYS
  end
end
