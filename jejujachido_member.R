## 지역(제주도) 데이터
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
jejujachido <- dbGetQuery(mydb,"select member_num from member where member_area = 'jejujachido';")
jejujachido_member <- jejujachido$member_num
jejujachido_member
length(jejujachido_member)
jejujachidodata <- dbGetQuery(mydb,"select * from setting;")
jejujachidodata
library(dplyr)
jejujachidodata2 <- subset(jejujachidodata, member_num %in% jejujachido_member, select = crawl_title)
jejujachidodata2

jejujachidodata3 <- sort(table(jejujachidodata2),decreasing = T) %>%
  head(5)
jejujachidodata3
jejujachidodata4 <- names(jejujachidodata3)
jejujachidodata4
jejujachidodata5 <-prop.table(jejujachidodata3)*100
jejujachidodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", jejujachidodata4[i] ,"\',
                     \'", jejujachidodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
