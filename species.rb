module Species
  extend self

  #KEYS = ['scientific_name','common_name','redlist_status','iucn_redlist_url'].freeze
  KEYS = %w(ID_NO HEX_ID binomial common_nam category).freeze
  THREATENED = %w(CR EN VU).freeze

  def threatened_list
    THREATENED.map { |c| "'#{c}'" }.join(',')
  end

  def keys
    KEYS
  end
end
