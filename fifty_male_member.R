library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
fiftymale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'male' and birth_y < '1971' and  birth_y > '1960';")
fiftymale_member <- fiftymale$member_num
fiftymale_member
length(fiftymale_member)
fiftymaledata <- dbGetQuery(mydb,"select * from setting;")
fiftymaledata
library(dplyr)
fiftymaledata2 <- subset(fiftymaledata, member_num %in% fiftymale_member, select = crawl_title)
fiftymaledata2

fiftymaledata3 <- sort(table(fiftymaledata2),decreasing = T) %>%
  head(5)
fiftymaledata3
fiftymaledata4 <- names(fiftymaledata3)
fiftymaledata4
fiftymaledata5 <-prop.table(fiftymaledata3)*100
fiftymaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", fiftymaledata4[i] ,"\',
                     \'", fiftymaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
