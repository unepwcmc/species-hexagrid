require 'byebug'

module Species
extend self

  def order_species species_data
    # Critically Endangered, Endangered, Vulnerable
    # CR is the most endangered, then comes EN, third VU
    # Fortunately these are alphabetically ordered.s
    species_data.sort_by! { |scientific_name, common_name, redlist_status, iucn_redlist_url| redlist_status }
  end
end
