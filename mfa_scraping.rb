
# require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'csv'

press_conf_urls = []
index_url = 'http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/'
index_doc = Nokogiri::HTML(open(index_url))
index_doc.css('.rebox_news a').each do |press_conf_a_tag|
  press_conf_urls << index_url + press_conf_a_tag[:href]
end

press_conf_hashes = []
press_conf_urls.each do |press_conf_url|
  press_conf = {}

  doc = Nokogiri::HTML(open(press_conf_url))
  press_conf[:title] = doc.at_css('#News_Body_Title').text
  press_conf[:date] = doc.at_css('#News_Body_Time').text
  press_conf[:body] = doc.at_css('#News_Body_Txt_A').text
  press_conf[:url] = press_conf_url

  press_conf_hashes << press_conf
  p press_conf[:date]
end

# p press_conf_hashes

# must include 'wb' as an argument here. why???
CSV.open("mfa_press_confs.csv", "wb") do |csv|
  csv << press_conf_hashes.first.keys
  press_conf_hashes.each do |hash|
    csv << hash.values
  end
end

# http://stackoverflow.com/questions/17325792/array-of-hashes-to-csv-file
# http://stackoverflow.com/questions/12718872/how-do-i-create-a-new-csv-file-in-ruby
# http://railscasts.com/episodes/190-screen-scraping-with-nokogiri?autoplay=true
# http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/
# http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/t1338806.shtml
# http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html
