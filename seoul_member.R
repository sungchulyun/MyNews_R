## 吏?뿭-?꽌?슱 異붿텛
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
seoul <- dbGetQuery(mydb,"select member_num from member where member_area = 'seoul';")
seoul_member <- seoul$member_num
seoul_member
length(seoul_member)
seouldata <- dbGetQuery(mydb,"select * from setting;")
seouldata
library(dplyr)
seouldata2 <- subset(seouldata, member_num %in% seoul_member, select = crawl_title)
seouldata2

seouldata3 <- sort(table(seouldata2),decreasing = T) %>%
  head(5)
seouldata3
seouldata4 <- names(seouldata3)
seouldata4
seouldata5 <-prop.table(seouldata3)*100
seouldata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", seouldata4[i] ,"\',
                     \'", seouldata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
