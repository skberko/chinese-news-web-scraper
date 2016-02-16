require 'nokogiri'
require 'open-uri'
require 'byebug'

# index_url1 = 'http://www.google.com'
# index_doc1 = Nokogiri::HTML(open(index_url1))

begin
  index_url2 = 'http://www.fmprc.gov.cn/web/fyrbt_673021/jzhsl_673025/default_68.shtml'
  index_doc2 = Nokogiri::HTML(open(index_url2))
  p 'no error'
rescue OpenURI::HTTPError => e
  debugger
  p e.message.to_s
end
