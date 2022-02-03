## 지역-경기도 추출
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
gyeonggido <- dbGetQuery(mydb,"select member_num from member where member_area = 'gyeonggido';")
gyeonggido_member <- gyeonggido$member_num
gyeonggido_member
length(gyeonggido_member)
gyeonggidodata <- dbGetQuery(mydb,"select * from setting;")
gyeonggidodata
library(dplyr)
gyeonggidodata2 <- subset(gyeonggidodata, member_num %in% gyeonggido_member, select = crawl_title)
gyeonggidodata2

gyeonggidodata3 <- sort(table(gyeonggidodata2),decreasing = T) %>%
  head(5)
gyeonggidodata3
gyeonggidodata4 <- names(gyeonggidodata3)
gyeonggidodata4
gyeonggidodata5 <-prop.table(gyeonggidodata3)*100
gyeonggidodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", gyeonggidodata4[i] ,"\',
                     \'", gyeonggidodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")