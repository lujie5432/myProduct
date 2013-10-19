require 'mysql'

conn=Mysql.real_connect('localhost','root','123','SearchEngine')
puts conn.methods

