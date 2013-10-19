require 'mysql'

class DbHelper

	CONN=Mysql.real_connect('localhost','root','123','SearchEngine')

	def self.exec(sql)
		begin
			CONN.query(sql)
		rescue=>err
			puts sql
		end
	end

	def self.query(sql)
		CONN.query(sql).each{|row| yield row }.free
	end

end
