## 지역(충청북도) 데이터
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
chungcheongnamdo <- dbGetQuery(mydb,"select member_num from member where member_area = 'chungcheongnamdo';")
chungcheongnamdo_member <- chungcheongnamdo$member_num
chungcheongnamdo_member
length(chungcheongnamdo_member)
chungcheongnamdodata <- dbGetQuery(mydb,"select * from setting;")
chungcheongnamdodata
library(dplyr)
chungcheongnamdodata2 <- subset(chungcheongnamdodata, member_num %in% chungcheongnamdo_member, select = crawl_title)
chungcheongnamdodata2

chungcheongnamdodata3 <- sort(table(chungcheongnamdodata2),decreasing = T) %>%
  head(5)
chungcheongnamdodata3
chungcheongnamdodata4 <- names(chungcheongnamdodata3)
chungcheongnamdodata4
chungcheongnamdodata5 <-prop.table(chungcheongnamdodata3)*100
chungcheongnamdodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", chungcheongnamdodata4[i] ,"\',
                     \'", chungcheongnamdodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
