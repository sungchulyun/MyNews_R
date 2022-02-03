## 吏?뿭(?쟾?씪?궓?룄)
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
jeonlanamdo <- dbGetQuery(mydb,"select member_num from member where member_area = 'jeonlanamdo';")
jeonlanamdo_member <- jeonlanamdo$member_num
jeonlanamdo_member
length(jeonlanamdo_member)
jeonlanamdodata <- dbGetQuery(mydb,"select * from setting;")
jeonlanamdodata
library(dplyr)
jeonlanamdodata2 <- subset(jeonlanamdodata, member_num %in% jeonlanamdo_member, select = crawl_title)
jeonlanamdodata2

jeonlanamdodata3 <- sort(table(jeonlanamdodata2),decreasing = T) %>%
  head(5)
jeonlanamdodata3
jeonlanamdodata4 <- names(jeonlanamdodata3)
jeonlanamdodata4
jeonlanamdodata5 <-prop.table(jeonlanamdodata3)*100
jeonlanamdodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", jeonlanamdodata4[i] ,"\',
                     \'", jeonlanamdodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
