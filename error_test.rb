require 'nokogiri'
require 'open-uri'
require 'byebug'

# index_url1 = 'http://www.google.com'
# index_doc1 = Nokogiri::HTML(open(index_url1))

index_url2 = 'http://www.google.com/zargots'
begin
  index_doc2 = Nokogiri::HTML(open(index_url2))
  p 'no error'
rescue OpenURI::HTTPError => error
  puts "first error's message is #{error.message.to_i}"
  if error.message == "404 Not Found"
    puts "sleeping for 5 sec!"
    sleep 5
    begin
      index_doc2 = Nokogiri::HTML(open(index_url2))
    rescue OpenURI::HTTPError => error2
      puts "second error's message is #{error2.message.to_i}"
    end
  else
    puts "well i guess we'll quit now :)"
  end
end
