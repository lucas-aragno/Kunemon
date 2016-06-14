require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://www.thedigi-zone.com/Card%20Scans.php'))

doc.search('td a').each do |link|
  href = link.attributes["href"].value
  if href.include?("Street") || href.include?("Series") || href.include?("cards")
    inside_page = Nokogiri::HTML(open("http://www.thedigi-zone.com/#{href}"))
    inside_page.search('p a').each do |img|
      card_href = img.attributes["href"].value
      unless card_href.include?("php") || card_href.include?("http://")
        p "Downloading http://www.thedigi-zone.com/#{card_href}"
        p "on directory #{File.dirname(__FILE__)}/cards/#{card_href}"
        begin
          name = card_href.split('/').last
          File.open("cards/#{name}", 'wb') do |fo|
            fo.write open("http://www.thedigi-zone.com/#{card_href}").read
          end
        rescue => e
          p "error #{e}"
        end
      end
    end
  end
end
