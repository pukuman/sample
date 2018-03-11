require 'bundler/setup'
require 'sqlite3'

@db = SQLite3::Database.new('./test.db')

if (@db.table_info('test01').size > 0) then
  sql='drop table test01'
  @db.execute(sql)
end
sql='create table test01 (' +
       ' col01 text primary key,' +
       ' col02 integer)'
@db.execute(sql)

(0..10).to_a.each{|i|
  sql = "insert into test01 values('#{sprintf("KEY%03d",i)}',#{i%3})"
  puts @db.execute(sql)
}

sql = "select distinct(col02) from test01"
puts @db.execute(sql)

###############################3
if (@db.table_info('test02').size > 0) then
  sql='drop table test02'
  @db.execute(sql)
end
sql='create table test02 (' +
       ' key01 integer primary key,' +
       ' key02 text ,' +
       ' col01 text ,' +
       ' primary key(key01,key02))'
@db.execute(sql)
(0..10).to_a.each{|i|
  sql = "insert into test02(key02,col01) values('#{sprintf("KEY%03d",i)}','#{sprintf("COL%03d",i)}')"
  puts sql
  @db.execute(sql)
}
sql = "delete from test02 where col01 = 'COL003'"
@db.execute(sql)
sql = "delete from test02 where col01 = 'COL007'"
@db.execute(sql)
sql = "insert into test02(key02,col01) values('KEY011','COL011')"
@db.execute(sql)
sql = "insert into test02(key02,col01) values('KEY012','COL012')"
@db.execute(sql)
sql = "insert into test02(key02,col01) values('KEY012','COL012-error')"
@db.execute(sql)
sql = "select key01,key02,col01 from test02 order by key01"
@db.execute(sql).each{|row|
  print row.join(","),"\n"
} 


@db.close
