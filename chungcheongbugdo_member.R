## 지역(충청북도) 데이터
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
chungcheongbugdo <- dbGetQuery(mydb,"select member_num from member where member_area = 'chungcheongbugdo';")
chungcheongbugdo_member <- chungcheongbugdo$member_num
chungcheongbugdo_member
length(chungcheongbugdo_member)
chungcheongbugdodata <- dbGetQuery(mydb,"select * from setting;")
chungcheongbugdodata
library(dplyr)
chungcheongbugdodata2 <- subset(chungcheongbugdodata, member_num %in% chungcheongbugdo_member, select = crawl_title)
chungcheongbugdodata2

chungcheongbugdodata3 <- sort(table(chungcheongbugdodata2),decreasing = T) %>%
  head(5)
chungcheongbugdodata3
chungcheongbugdodata4 <- names(chungcheongbugdodata3)
chungcheongbugdodata4
chungcheongbugdodata5 <-prop.table(chungcheongbugdodata3)*100
chungcheongbugdodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", chungcheongbugdodata4[i] ,"\',
                     \'", chungcheongbugdodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
