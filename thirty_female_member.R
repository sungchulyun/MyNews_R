library(RMySQL)
mydb <- dbConnect(MySQL(),user='root',password='1111',dbname='realpractice')
mydb
result <- dbGetQuery(mydb,'show tables;')
result
thirtyfemale <- dbGetQuery(mydb,"select member_num from member WHERE gender  = 'female' and birth_y < '1991' and  birth_y > '1980';")
thirtyfemale_member <- thirtyfemale$member_num
thirtyfemale_member
length(thirtyfemale_member)
thirtyfemaledata <- dbGetQuery(mydb,"select * from setting;")
thirtyfemaledata
library(dplyr)
thirtyfemaledata2 <- subset(thirtyfemaledata, member_num %in% thirtyfemale_member, select = crawl_title)
thirtyfemaledata2

thirtyfemaledata3 <- sort(table(thirtyfemaledata2),decreasing = T) %>%
  head(5)
thirtyfemaledata3
thirtyfemaledata4 <- names(thirtyfemaledata3)
thirtyfemaledata4
thirtyfemaledata5 <-prop.table(thirtyfemaledata3)*100
thirtyfemaledata5
for(i in 1:5){
  dbSendQuery(mydb,
              paste0("INSERT INTO practice3
                     (url, percent)
                     VALUES
                     (\'", thirtyfemaledata4[i] ,"\',
                     \'", thirtyfemaledata5[i] ,"\')"))
}
dbGetQuery(mydb,"select *from practice3;")
