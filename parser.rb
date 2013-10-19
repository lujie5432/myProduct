class Parser
	def initialize(url,content)
		begin
			@islegal=(CONTENT_FORMAT=~content)!=nil
		rescue
			puts content
		end
		if @islegal
			initPathes(url)
			@content=content
		end
	end

	URL_FORMAT=/\b(([\w-]+:\/\/?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|\/)))/im
	CONTENT_FORMAT=/<body.*?>.+<\/body.*?>/im
	REG_LINK=/<a.*?href=["']??\b([\w\/\.\?:]+)\b["']??.*?>/i
	REG_TITLE=/<title.*>\s*(.+)\s*<\/title/i

	#通过正则表达式分析取出content中的URL
	def getLinks
		return unless @islegal
		urls=[]
		@content.scan(REG_LINK).each do |matches|
			url=matches[0].gsub('\\','/').gsub(/\s/,'')
			md=/\w*?\:/.match(url)
			if md!=nil
				return unless md[0]=='http:'
			else
				if url.start_with?('/')
					url='http://'<<@urlPathes[0]<<url
				else
					backlength=url.scan('../').length
					url='http://'<<(@urlPathes[0,@urlPathes.length-backlength].join('/'))<<'/'<<(url.delete('../'))
				end
			end
			urls.push(url) if (URL_FORMAT=~url)!=nil&&!urls.include?(url)
		end
		urls
	end

	#获取网页标题
	def getTitle
		return unless @islegal
		md=REG_TITLE.match(@content)
		md[1].gsub(/[\s'"\|,\.\?]+/m,' ') unless md==nil
	end

	#获取当前URL的路径结构
	def initPathes(url)
		url=url.delete "http://"
		url=url[0,url.index("/")] if url.include?("/")
		
		@urlPathes=url.gsub('\\','/').split("/")
	end

	def parseContent
		return unless @islegal
		md=CONTENT_FORMAT.match(@content)
		if md!=nil
			data=md[0]
			#去除不需要的标签及其内容
			['script','style'].each do |tag|
				data=data.gsub(Regexp.new("<#{tag}.*?>.*?</#{tag}\s*>",Regexp::MULTILINE|Regexp::IGNORECASE),'')
			end

			#去除所有标签#去掉转意&lt;&gt;&nbsp;#去掉多余的空格
			data.gsub(/<.*?>/m,' ').gsub(/(&nbsp;)|(&gt)|(&lt)/,' ').gsub(/[\s'"\|,\.\?]+/m,' ')
		end
	end
end
