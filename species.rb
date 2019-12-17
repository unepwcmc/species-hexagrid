module Species
  extend self

  KEYS = ['scientific_name','common_name','redlist_status','iucn_redlist_url'].freeze

  def order_species species_data
    # Critically Endangered, Endangered, Vulnerable
    # CR is the most endangered, then comes EN, third VU
    # Fortunately these are alphabetically ordered.s
    species_data.sort_by! { |hash| hash['redlist_status'] }
  end

  def keys
    KEYS
  end
end
