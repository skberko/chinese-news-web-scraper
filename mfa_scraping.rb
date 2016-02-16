require 'nokogiri'
require 'open-uri'
require 'csv'

start_time = Time.now
puts "\nStarted scraping at #{Time.now}"

# creates csv doc and adds four relevant column names:
CSV.open("mfa_press_confs.csv", "wb") do |csv|
  column_titles = %w(title date body url)
  csv << column_titles
end

keepgoing = true
index_idx = 0
base_conf_url = 'http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/'
index_url = 'http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/'
index_doc = Nokogiri::HTML(open(index_url))

while keepgoing
  curr_index_press_conf_urls = []
  index_doc.css('.rebox_news a').each do |press_conf_a_tag|
    curr_index_press_conf_urls << base_conf_url + press_conf_a_tag[:href]
  end

  curr_index_press_conf_urls.each do |press_conf_url|
    press_conf = {}

    press_conf_doc = Nokogiri::HTML(open(press_conf_url))
    press_conf[:title] = press_conf_doc.at_css('#News_Body_Title').text
    press_conf[:date] = press_conf_doc.at_css('#News_Body_Time').text
    press_conf[:body] = press_conf_doc.at_css('#News_Body_Txt_A').text
    press_conf[:url] = press_conf_url

    CSV.open("mfa_press_confs.csv", "ab") do |csv|
      csv << press_conf.values
    end

    # include print statement so progress is reflected in terminal
    puts "#{press_conf[:date]} scraped and appended"
  end

  begin
    index_idx += 1
    index_url = 'http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/default_' + index_idx.to_s + '.shtml'
    index_doc = Nokogiri::HTML(open(index_url))
  rescue OpenURI::HTTPError => error
    if error.message.to_i == 502
      puts "\nHit a 502 (Bad Gateway) error. Will retry scraping this URL in 120 seconds, at #{Time.now}."
      sleep 120
      begin
        index_doc = Nokogiri::HTML(open(index_url))
      rescue OpenURI::HTTPError => error2
        puts "\nAfter an initial 502 error, slept 120 seconds and retried same URL.\nHowever, there was another error.\nThis time, it was '#{error2.message}'"
        keepgoing = false
      end
    elsif error.message.to_i == 403
      puts "\nHit a 403 (Forbidden) error. Possibly banned from the site now."
    elsif error.message.to_i == 404
      keepgoing = false
      puts "\nHit a 404 (Not Found) error - either there was a URL issue, or scraping is complete!"
    else
      keepgoing = false
      puts "\nThere was an unexpected error: '#{error.message}'. Uh oh!"
    end
  end
end

puts "\nScraping took #{(Time.now - start_time).to_i} seconds."

# p "\nAll press conferences scraped and appended to mfa_press_confs.csv"



# http://stackoverflow.com/questions/17325792/array-of-hashes-to-csv-file
# https://github.com/sparklemotion/nokogiri/wiki/From-jQuery
# http://stackoverflow.com/questions/12718872/how-do-i-create-a-new-csv-file-in-ruby
# http://railscasts.com/episodes/190-screen-scraping-with-nokogiri?autoplay=true
# http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/
# http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/t1338806.shtml
# http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html
# http://stackoverflow.com/questions/3682359/what-are-the-ruby-file-open-modes-and-options
# http://mikeferrier.com/2012/05/19/rescuing-multiple-exception-types-in-ruby-and-binding-to-local-variable/
