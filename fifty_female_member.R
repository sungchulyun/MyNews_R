library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
fiftyfemale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'female' and birth_y < '1971' and  birth_y > '1960';")
fiftyfemale_member <- fiftyfemale$member_num
fiftyfemale_member
length(fiftyfemale_member)
fiftyfemaledata <- dbGetQuery(mydb,"select * from setting;")
fiftyfemaledata
library(dplyr)
fiftyfemaledata2 <- subset(fiftyfemaledata, member_num %in% fiftyfemale_member, select = crawl_title)
fiftyfemaledata2

fiftyfemaledata3 <- sort(table(fiftyfemaledata2),decreasing = T) %>%
  head(5)
fiftyfemaledata3
fiftyfemaledata4 <- names(fiftyfemaledata3)
fiftyfemaledata4
fiftyfemaledata5 <-prop.table(fiftyfemaledata3)*100
fiftyfemaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", fiftyfemaledata4[i] ,"\',
                     \'", fiftyfemaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
