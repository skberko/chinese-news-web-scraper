require 'nokogiri'
require 'open-uri'
require 'csv'

start_time = Time.now
puts "\nStarted scraping at #{Time.now}"

CSV.open("mfa_press_confs.csv", "wb") do |csv|
  column_titles = %w(title date body url)
  csv << column_titles
end

keep_going = true
index_idx = 0
base_conf_url = 'https://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/'
index_url = 'https://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/'
index_doc = Nokogiri::HTML(open(index_url))
breakout_early_for_403 = false

while keep_going
  puts "\nNow scraping links from index page #{index_idx}."
  curr_index_press_conf_urls = []
  index_doc.css('.rebox_news a').each do |press_conf_a_tag|
    url_ending = press_conf_a_tag[:href].split('')[2..-1].join
    curr_index_press_conf_urls << base_conf_url + url_ending
  end

  curr_index_press_conf_urls.each do |press_conf_url|
    press_conf = {}

    try_next_press_conf = false
    until try_next_press_conf
      begin
        press_conf_doc = Nokogiri::HTML(open(press_conf_url))
        press_conf[:title] = press_conf_doc.at_css('#News_Body_Title').text
        press_conf[:date] = press_conf_doc.at_css('#News_Body_Time').text
        press_conf[:body] = press_conf_doc.at_css('#News_Body_Txt_A').text
        press_conf[:url] = press_conf_url
        try_next_press_conf = true
      rescue OpenURI::HTTPError, ArgumentError, NoMethodError => error
        if error.message.to_i == 404
          try_next_press_conf = true
          puts "\nSingle Conference Page:\nHit error #{error.message}.\nThe press conference at #{press_conf_url} does not exist!"
        elsif error.message.to_i == 403
          breakout_early_for_403 = true
          puts "\nSingle Conference Page:\n***Hit error #{error.message}, so ending scraping to avoid further issues.***"
        else
          puts "Single Conference Page:\nSleeping for 120 sec to deal with #{error.message}"
          sleep 120
        end
      end
      break if breakout_early_for_403
    end

    unless breakout_early_for_403
      CSV.open("mfa_press_confs.csv", "ab") do |csv|
        csv << press_conf.values
      end

      puts "#{press_conf[:date]} scraped and appended to csv"
    end
  end

  unless breakout_early_for_403
    index_idx += 1
    index_url = 'https://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/default_' + index_idx.to_s + '.shtml'
    no_err_besides_404 = false
    until no_err_besides_404
      begin
        index_doc = Nokogiri::HTML(open(index_url))
        no_err_besides_404 = true
      rescue OpenURI::HTTPError, ArgumentError, NoMethodError => error
        if error.message.to_i == 404
          no_err_besides_404 = true
          keep_going = false
          puts "\nNew Index Page:\nHit error #{error.message}. Either there was a URL issue, or scraping is complete!"
        elsif error.message.to_i == 403
          keep_going = false
          breakout_early_for_403 = true
          puts "\nNew Index Page:\nHit error #{error.message}, so ending scraping to avoid further issues."
        else
          puts "\nNew Index Page:\nSleeping for 120 sec to deal with #{error.message}"
          sleep 120
        end
      end
      break if breakout_early_for_403
    end
  end
  break if breakout_early_for_403
end

if breakout_early_for_403
  puts "\n**WARNING: BROKE OUT OF THE SCRIPT EARLY AFTER ENCOUNTERING A 403 ERROR**"
  puts "TIME UNTIL 403 ERROR WAS #{(Time.now - start_time).to_i} SECONDS."
else
  puts "\nScraping took #{(Time.now - start_time).to_i} seconds."
end
