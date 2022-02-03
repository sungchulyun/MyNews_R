library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
fortymale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'male' and birth_y < '1981' and  birth_y > '1970';")
fortymale_member <- fortymale$member_num
fortymale_member
length(fortymale_member)
fortymaledata <- dbGetQuery(mydb,"select * from setting;")
fortymaledata
library(dplyr)
fortymaledata2 <- subset(fortymaledata, member_num %in% fortymale_member, select = crawl_title)
fortymaledata2

fortymaledata3 <- sort(table(fortymaledata2),decreasing = T) %>%
  head(5)
fortymaledata3
fortymaledata4 <- names(fortymaledata3)
fortymaledata4
fortymaledata5 <-prop.table(fortymaledata3)*100
fortymaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", fortymaledata4[i] ,"\',
                     \'", fortymaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
