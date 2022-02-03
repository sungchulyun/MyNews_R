library(RMySQL)
mydb <- dbConnect(MySQL(),user = 'root', password = '1111',dbname = 'realpractice',localhost = 'localhost')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
dbGetQuery(mydb,"desc setting;")
commondata <- dbGetQuery(mydb,"select crawl_title from setting;")
commondata
library(dplyr)
commondata2 <- sort(table(commondata),decreasing = T) %>%
  head(5)
commondata2
commondata3 <- names(commondata2)
commondata3
commondata4 <-prop.table(commondata2)*100
commondata4
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", commondata3[i] ,"\',
                     \'", commondata4[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
