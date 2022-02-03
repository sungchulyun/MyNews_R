library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
teenfemale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'female' and birth_y > '2000';")
teenfemale_member <- teenfemale$member_num
teenfemale_member
length(teenfemale_member)
teenfemaledata <- dbGetQuery(mydb,"select * from setting;")
teenfemaledata
library(dplyr)
teenfemaledata2 <- subset(teenfemaledata, member_num %in% teenfemale_member, select = crawl_title)
teenfemaledata2

teenfemaledata3 <- sort(table(teenfemaledata2),decreasing = T) %>%
  head(5)
teenfemaledata3
teenfemaledata4 <- names(teenfemaledata3)
teenfemaledata4
teenfemaledata5 <-prop.table(teenfemaledata3)*100
teenfemaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", teenfemaledata4[i] ,"\',
                     \'", teenfemaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
