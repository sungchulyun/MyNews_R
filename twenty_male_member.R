library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
twentymale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'male' and birth_y < '2000' and  birth_y > '1991';")
twentymale_member <- twentymale$member_num
twentymale_member
length(twentymale_member)
twentymaledata <- dbGetQuery(mydb,"select * from setting;")
twentymaledata
library(dplyr)
twentymaledata2 <- subset(twentymaledata, member_num %in% twentymale_member, select = crawl_title)
twentymaledata2

twentymaledata3 <- sort(table(twentymaledata2),decreasing = T) %>%
  head(5)
twentymaledata3
twentymaledata4 <- names(twentymaledata3)
twentymaledata4
twentymaledata5 <-prop.table(twentymaledata3)*100
twentymaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", twentymaledata4[i] ,"\',
                     \'", twentymaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")