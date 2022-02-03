## 지역(충청북도) 데이터
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
gyeongsangnamdo <- dbGetQuery(mydb,"select member_num from member where member_area = 'gyeongsangnamdo';")
gyeongsangnamdo_member <- gyeongsangnamdo$member_num
gyeongsangnamdo_member
length(gyeongsangnamdo_member)
gyeongsangnamdodata <- dbGetQuery(mydb,"select * from setting;")
gyeongsangnamdodata
library(dplyr)
gyeongsangnamdodata2 <- subset(gyeongsangnamdodata, member_num %in% gyeongsangnamdo_member, select = crawl_title)
gyeongsangnamdodata2

gyeongsangnamdodata3 <- sort(table(gyeongsangnamdodata2),decreasing = T) %>%
  head(5)
gyeongsangnamdodata3
gyeongsangnamdodata4 <- names(gyeongsangnamdodata3)
gyeongsangnamdodata4
gyeongsangnamdodata5 <-prop.table(gyeongsangnamdodata3)*100
gyeongsangnamdodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", gyeongsangnamdodata4[i] ,"\',
                     \'", gyeongsangnamdodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
