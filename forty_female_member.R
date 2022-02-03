library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
fortyfemale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'female' and birth_y < '1981' and  birth_y > '1970';")
fortyfemale_member <- fortyfemale$member_num
fortyfemale_member
length(fortyfemale_member)
fortyfemaledata <- dbGetQuery(mydb,"select * from setting;")
fortyfemaledata
library(dplyr)
fortyfemaledata2 <- subset(fortyfemaledata, member_num %in% fortyfemale_member, select = crawl_title)
fortyfemaledata2

fortyfemaledata3 <- sort(table(fortyfemaledata2),decreasing = T) %>%
  head(5)
fortyfemaledata3
fortyfemaledata4 <- names(fortyfemaledata3)
fortyfemaledata4
fortyfemaledata5 <-prop.table(fortyfemaledata3)*100
fortyfemaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", fortyfemaledata4[i] ,"\',
                     \'", fortyfemaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
