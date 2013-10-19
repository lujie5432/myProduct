require 'open-uri'
require 'parser'

class CrawlHelper
	def initialize(urls)
		@urls=urls
	end

	def start(&cb)
		@urls.each do |line|
			data=nil
			begin
				data=getContent(line)
			rescue
			end
			cb.call(line,data)
		end
	end

	def getContent(url)
		res=nil
		open(url){|http| res=http.read}
		res
	end

end
