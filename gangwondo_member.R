## 지역-강원도 추출
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
gangwondo <- dbGetQuery(mydb,"select member_num from member where member_area = 'gangwondo';")
gangwondo_member <- gangwondo$member_num
gangwondo_member
length(gangwondo_member)
gangwondodata <- dbGetQuery(mydb,"select * from setting;")
gangwondodata
library(dplyr)
gangwondodata2 <- subset(gangwondodata, member_num %in% gangwondo_member, select = crawl_title)
gangwondodata2

gangwondodata3 <- sort(table(gangwondodata2),decreasing = T) %>%
  head(5)
gangwondodata3
gangwondodata4 <- names(gangwondodata3)
gangwondodata4
gangwondodata5 <-prop.table(gangwondodata3)*100
gangwondodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO R_area
                     (crawl_title)
                     VALUES
                     (\'", gangwondodata4[i] ,"\')"))
}
dbGetQuery(mydb,"select crawl_title1 from R_area;")
