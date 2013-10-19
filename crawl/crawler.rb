require 'crawl/crawlHelper'
require 'db/dbhelper'

urls=File.open('urls')
for i in 0..5 do
	CrawlHelper.new(urls).start do |url,content|
		DbHelper.exec("insert into CrawlUrl(Url,LastTime) values(\'#{url}\',\'now\')")
		
	end
end


