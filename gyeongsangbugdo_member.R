## 지역(충청북도) 데이터
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
gyeongsangbugdo <- dbGetQuery(mydb,"select member_num from member where member_area = 'gyeongsangbugdo';")
gyeongsangbugdo_member <- gyeongsangbugdo$member_num
gyeongsangbugdo_member
length(gyeongsangbugdo_member)
gyeongsangbugdodata <- dbGetQuery(mydb,"select * from setting;")
gyeongsangbugdodata
library(dplyr)
gyeongsangbugdodata2 <- subset(gyeongsangbugdodata, member_num %in% gyeongsangbugdo_member, select = crawl_title)
gyeongsangbugdodata2

gyeongsangbugdodata3 <- sort(table(gyeongsangbugdodata2),decreasing = T) %>%
  head(5)
gyeongsangbugdodata3
gyeongsangbugdodata4 <- names(gyeongsangbugdodata3)
gyeongsangbugdodata4
gyeongsangbugdodata5 <-prop.table(gyeongsangbugdodata3)*100
gyeongsangbugdodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", gyeongsangbugdodata4[i] ,"\',
                     \'", gyeongsangbugdodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
