# ruby-web-crawler
A simple Web Crawler to recursively follow links and get all the child Links. 
It also supports URL forwarding caused by redirection.

###Installation

    gem install ruby-web-crawler

###Using the Gem

    crawler = RubyWebCrawler.new 'http://example.com'
    urls = crawler.start_crawl    # Returns an Array of all URLs

###Configuration

Change number of URLs the crawler will traverse before it stops

    crawler = RubyWebCrawler.new 'http://example.com', 100
OR

    crawler.url_limit = 100  # Default 50 (Applicable before calling `start_crawl`)
<br>
<br>
Change the execution time limit of the Crawl (In Seconds)

    crawler = RubyWebCrawler.new 'http://example.com', 100, 120
OR

    crawler.time_limit = 120  # Default 60 (Applicable before calling `start_crawl`)
