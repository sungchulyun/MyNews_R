library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
thirtymale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'male' and birth_y < '1991' and  birth_y > '1980';")
thirtymale_member <- thirtymale$member_num
thirtymale_member
length(thirtymale_member)
thirtymaledata <- dbGetQuery(mydb,"select * from setting;")
thirtymaledata
library(dplyr)
thirtymaledata2 <- subset(thirtymaledata, member_num %in% thirtymale_member, select = crawl_title)
thirtymaledata2

thirtymaledata3 <- sort(table(thirtymaledata2),decreasing = T) %>%
  head(5)
thirtymaledata3
thirtymaledata4 <- names(thirtymaledata3)
thirtymaledata4
thirtymaledata5 <-prop.table(thirtymaledata3)*100
thirtymaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", thirtymaledata4[i] ,"\',
                     \'", thirtymaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
