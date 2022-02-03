library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
teenmale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'male' and birth_y > '2000';")
teenmale_member <- teenmale$member_num
teenmale_member
length(teenmale_member)
teenmaledata <- dbGetQuery(mydb,"select * from setting;")
teenmaledata
library(dplyr)
teenmaledata2 <- subset(teenmaledata, member_num %in% teenmale_member, select = crawl_title)
teenmaledata2

teenmaledata3 <- sort(table(teenmaledata2),decreasing = T) %>%
  head(5)
teenmaledata3
teenmaledata4 <- names(teenmaledata3)
teenmaledata4
teenmaledata5 <-prop.table(teenmaledata3)*100
teenmaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", teenmaledata4[i] ,"\',
                     \'", teenmaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
