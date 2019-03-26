# MFA Press Conference Web Scraper

In a previous life, I dabbled in China-focused journalism (see [here](http://foreignpolicy.com/2015/01/05/its-official-the-man-who-ruled-china-has-all-but-vanished/) for an example). My research frequently involved combing through thousands of official press documents in the original Mandarin Chinese to find evidence of shifts in government policy. Naturally, the more data available to me, the more inefficient it became to do this manually.

In order to automate this process, I have written a web scraping script in Ruby to grab text data for me and store it in a CSV file. The sample data set I used for this proof of concept exercise is a collection of over 1,000 press conference transcripts from the [Chinese Ministry of Foreign Affairs](http://www.fmprc.gov.cn/web/) (MFA). The MFA updates its site with new transcripts every couple of days, and this script will grab the full historical set every time it is run.

# Site scraped

To access each press conference transcript, the script must traverse index pages with links to 16 transcript per page, scrape each of these transcripts, then move onto the next index page.

To see an example of an index page, click [here](http://www.fmprc.gov.cn/web/sp_683685/wjbfyrlxjzh_683691/).

To see an example of an actual transcript (i.e. the data being written to the CSV file), click [here](http://www.fmprc.gov.cn/web/sp_683685/wjbfyrlxjzh_683691/t1340853.shtml).

# Technologies used

- The Ruby [Nokogiri](http://www.nokogiri.org/) gem, to convert HTML documents into custom parseable Ruby objects and isolate data from them using CSS selectors
- The Ruby [OpenURI](http://ruby-doc.org/stdlib-2.1.2/libdoc/open-uri/rdoc/OpenURI.html) module, for its HTTP-wrapping goodness
- The Ruby [CSV](http://ruby-doc.org/stdlib-2.1.2/libdoc/csv/rdoc/CSV.html) module, to create and edit a CSV file to store the data scraped
- A bunch of fun Ruby [error handling](http://ruby-doc.org/core-2.1.2/Exception.html) tricks

# Challenges

- The main challenge to overcome in this project was encountering frequent HTTP errors once I ran my script and started the actual scraping process
- In particular, there were a wide variety of 5xx-class HTTP errors, presumably due to sever errors on the part of the Chinese MFA's site
- I was also conscious of the possibility that the site would not be particularly happy to be scraped, leading to 403 errors
- To deal with these issues, I wrote robust error handling solutions into my code to deal with all eventualities

# How to run this script

- Clone this repo.
- Make sure you have installed the [Nokogiri](http://www.nokogiri.org/) Ruby gem on your machine (to do this, run `gem install nokogiri`).
- Navigate to the cloned repo, then run `ruby mfa_scraping.rb`.
- The script should take less than half an hour to run, though YMMV depending on network speed.

# Results

- Results of the script will be printed out to the  the `mfa_press_confs.csv` file in this repo
- Be aware that every time you rerun the script, you will overwrite this .csv file!

# Resources Consulted

- [http://stackoverflow.com/questions/17325792/array-of-hashes-to-csv-file](http://stackoverflow.com/questions/17325792/array-of-hashes-to-csv-file)
- [https://github.com/sparklemotion/nokogiri/wiki/From-jQuery](https://github.com/sparklemotion/nokogiri/wiki/From-jQuery)
- [http://stackoverflow.com/questions/12718872/how-do-i-create-a-new-csv-file-in-ruby](http://stackoverflow.com/questions/12718872/how-do-i-create-a-new-csv-file-in-ruby)
- [http://railscasts.com/episodes/190-screen-scraping-with-nokogiri?autoplay=true](http://railscasts.com/episodes/190-screen-scraping-with-nokogiri?autoplay=true)
- [http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html](http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html)
- [http://mikeferrier.com/2012/05/19/rescuing-multiple-exception-types-in-ruby-and-binding-to-local-variable/](http://mikeferrier.com/2012/05/19/rescuing-multiple-exception-types-in-ruby-and-binding-to-local-variable/)
