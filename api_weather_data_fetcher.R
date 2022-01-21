#---- libraries ----

library(jsonlite)
library(dplyr)

#---- set up url ----

url1 <- as.character("https://raw.githubusercontent.com/data-hydenv/data/master/extra/weather/data/2021_12_")

num1 <- as.character("12")

url2 <- as.character("_raw_dump.json")

url3 <- as.character("https://raw.githubusercontent.com/data-hydenv/data/master/extra/weather/data/2022_1_")

urlt <- paste(url1, num1, url2, sep= "")
urlt

# for january

num2 <- as.character("1")

# ---- empty data frame

dtt <- data.frame(dttm =as.Date(character()), th = as.double(double())) 

##---- while machine ----

while (as.integer(num1) < 42) {
  
  #---- json importer  ----  
  
  js <- fromJSON(urlt, flatten =TRUE)
  
  jdf <- js$historic$hourly %>% as.data.frame()
  
  dfor <- jdf %>% select(dt, temp)%>% 
    mutate(th = temp) %>% 
    mutate(dttm = as.POSIXct(dt, origin ="1970-01-01")) %>% 
    select(dttm, th)
  
  #---- create data frame ----
  
  dtt <- union(dtt, dfor)
  
  #---- names and url update ----
  
  ifelse(num1 < 31, #condition yes = december
         
         {
           
           num1 <- ifelse(num1 == 26, as.integer(num1) + 2, as.integer(num1) + 1)
           
           urlt <- paste(url1, as.character(num1), url2, sep= "")}, # yes
         
         { # no = january
           
           num1 <- as.integer(num1) + 1
           
           urlt <- paste(url3, num2, url2, sep= "")
           
           num2 <- as.integer(num2) + 1} # no
         
  )}

dtt <- dtt %>% filter(dttm > "2021-12-13", dttm < "2022-01-10")

# ++++++++ remember to change the path and file name below +++++++++

#write.csv(dtt, file = '~/your_path/file_name.csv', row.names = FALSE, quote = FALSE)
