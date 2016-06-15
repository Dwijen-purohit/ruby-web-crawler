require 'net/http'
require 'uri'

module RubyWebCrawler

	class Crawler
		
		@url_limit = 50 # Default URL Limit for the Crawler
		@time_limit = 60 # Timeout limit in seconds

		attr_accessor :urls, :root_url, :url_limit, :time_limit

		def initialize url
			self.urls = []
			self.root_url = url
		end

		def start_crawl
			begin
				is_running = Timeout::timeout(self.time_limit) {
					self.get_urls_for_page self.root_url	
				}	
			rescue Exception => e
				# Do Nothing just don't let it error out
			end
			return self.urls
		end

		# Get all URLs on a Page
		def get_urls_for_page url
			puts "Working ... "
			page_content = self.get_page_content url
			
			# Regex to get all "links" in the page
			urls = page_content.scan(/\<a href\=(\"(http|https)\:.*?\")/)			
			urls.each { |u| 
				sanitized_url = u.first.gsub(/\"/, '').strip
				unless self.urls.include? sanitized_url
					self.urls.push(sanitized_url)

					# If Unexpected Error happens when trying to fetch URLs move on to the next URL
					begin
						break if self.urls.count >= self.url_limit
						self.get_urls_for_page(sanitized_url)	
					rescue Exception => e
						next
					end
				end
			}
			return self.urls
		end

		# Get HTML/Content of the Page to be parsed
		def get_page_content url
			uri = URI(url)
			request = Net::HTTP::Get.new(uri)

			http = Net::HTTP.new(uri.host, uri.port)
			
			# Neet to enable use of SSL if the URL protocol is HTTPS
			http.use_ssl = (uri.scheme == "https")

			response = http.request(request)

			# Check if URL needs to be forwarded because of redirect
			case response
			when Net::HTTPSuccess
				return response.body
			when Net::HTTPMovedPermanently || Net::HTTPRedirection
				self.get_page_content response['location']
			end
		end


	end # END Crawler
	
end # END RubyWebCrawler