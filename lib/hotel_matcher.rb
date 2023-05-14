require 'nokogiri'
require 'open-uri'

class HotelMatcher
  def find_urls(hotel_name)
    urls = []

    # Tripadvisor
    url = "https://www.tripadvisor.com/Search?q=#{hotel_name}"
    doc = Nokogiri::HTML(open(url))
    result = doc.css('.result-title a').first
    urls << result['href'] if result

    # Booking
    url = "https://www.booking.com/searchresults.pt-br.html?label=gen173nr-1FCAEoggI46AdIM1gEaGKIAQGYAQm4AQfIAQzYAQHoAQH4AQKIAgGoAgO4As6V9_4FwAIB;sid=33bbca9b4d2f558d5d5d5d2e07e3ef4f;tmpl=searchresults&checkin_month=5&checkin_monthday=14&checkin_year=2023&checkout_month=5&checkout_monthday=15&checkout_year=2023&
    dest_id=&dest_type=&dtdisc=0&from_sf=1&group_adults=1&group_children=0&highlighted_hotels=3574594&hp_sbox=1&no_rooms=1&order=price_ascending&raw_dest_type=hotel&room1=A%2CA&sb_price_type=total&search_selected=1&ss=doubletree+hilton+amsterdam&ss_raw=doubletree+hilton+amsterdam&src=searchresults&srpvid=1a8537ae9c2c013d&ssb=empty&ssne=Amsterdam-~-North-Holland-~-Netherlands&ssne_untouched=Amsterdam-~-North-Holland-~-Netherlands&rows=15"
    doc = Nokogiri::HTML(open(url))
    result = doc.css('.sr-hotel__title a').first
    urls << result['href'] if result

    # Holidaycheck
    url = "https://www.holidaycheck.de/suche?sd=2023-05-14&ed=2023-05-15&hc_search=1&hc_limit=20&destination_name=Amsterdam&region_id=46&hotel_name=#{hotel_name}"
    doc = Nokogiri::HTML(open(url))
    result = doc.css('.hotel_name a').first
    urls << result['href'] if result

    # Tripadvisor
doc = Nokogiri::HTML(open(url))
result = doc.css('.result-title a').first
urls << result['href'] if result

# Booking
doc = Nokogiri::HTML(open(url))
result = doc.css('.sr-hotel__title a').first
urls << result['href'] if result

# Holidaycheck
doc = Nokogiri::HTML(open(url))
result = doc.css('.hotel_name a').first
urls << result['href'] if result

    return urls
  end
end

require 'bunny'

class HotelMatcher
  def find_urls(hotel_name)
    urls = []

    # o código para encontrar os URLs dos sites Tripadvisor, Booking e Holidaycheck aqui

    # envia os URLs encontrados para a fila
    conn = Bunny.new
    conn.start

    ch = conn.create_channel
    q = ch.queue('hotel_urls')
    urls.each do |url|
      ch.default_exchange.publish(url, routing_key: q.name)
    end

    conn.close
  end
end