require 'nokogiri'
require 'open-uri'
require 'byebug'

# index_url1 = 'http://www.google.com'
# index_doc1 = Nokogiri::HTML(open(index_url1))

begin
  index_url2 = 'http://www.google.com/zargots'
  index_doc2 = Nokogiri::HTML(open(index_url2))
  p 'no error'
rescue OpenURI::HTTPError => error
  if error.message.to_i == 404
    puts "hello, dolly!"
  else
    puts "well that explains it :)"
  end
end

puts ""

index_doc2 = Nokogiri::HTML(open(index_url2))
