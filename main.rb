$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'crawl/crawlHelper'
require 'db/dbhelper'
require 'parser'

urls=File.open('urls')

for i in 0..2 do
	newUrls=[]
	CrawlHelper.new(urls).start do |url,content|
		DbHelper.exec("insert into CrawlUrl(Url,LastTime) values (\'#{url}\',now())")
		#puts url
		#puts content	

		parser=Parser.new(url,content)
		content=parser.parseContent
		title=parser.getTitle
		DbHelper.exec("insert into CrawlData(Url,Title,Content,Status) values(\'#{url}\',\'#{title}\',\'#{content}\',0)")
		urls=parser.getLinks 
	end
	urls=newUrls
end
