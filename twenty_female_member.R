library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
twentyfemale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'female' and birth_y < '2000' and  birth_y > '1991';")
twentyfemale_member <- twentyfemale$member_num
twentyfemale_member
length(twentyfemale_member)
twentyfemaledata <- dbGetQuery(mydb,"select * from setting;")
twentyfemaledata
library(dplyr)
twentyfemaledata2 <- subset(twentyfemaledata, member_num %in% twentyfemale_member, select = crawl_title)
twentyfemaledata2

twentyfemaledata3 <- sort(table(twentyfemaledata2),decreasing = T) %>%
  head(5)
twentyfemaledata3
twentyfemaledata4 <- names(twentyfemaledata3)
twentyfemaledata4
twentyfemaledata5 <-prop.table(twentyfemaledata3)*100
twentyfemaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", twentyfemaledata4[i] ,"\',
                     \'", twentyfemaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
