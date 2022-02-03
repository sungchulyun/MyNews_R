## 지역(충청북도) 데이터
library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
jeonlabugdo <- dbGetQuery(mydb,"select member_num from member where member_area = 'jeonlabugdo';")
jeonlabugdo_member <- jeonlabugdo$member_num
jeonlabugdo_member
length(jeonlabugdo_member)
jeonlabugdodata <- dbGetQuery(mydb,"select * from setting;")
jeonlabugdodata
library(dplyr)
jeonlabugdodata2 <- subset(jeonlabugdodata, member_num %in% jeonlabugdo_member, select = crawl_title)
jeonlabugdodata2

jeonlabugdodata3 <- sort(table(jeonlabugdodata2),decreasing = T) %>%
  head(5)
jeonlabugdodata3
jeonlabugdodata4 <- names(jeonlabugdodata3)
jeonlabugdodata4
jeonlabugdodata5 <-prop.table(jeonlabugdodata3)*100
jeonlabugdodata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", jeonlabugdodata4[i] ,"\',
                     \'", jeonlabugdodata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
