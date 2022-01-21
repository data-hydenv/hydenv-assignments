--------- Short Description ----------

This R script downloads, cleans and creates a data frame out of all the .json files derived from the weather API automatically, then prints a .csv file. Should work on every machine.

The variables are selected from the "historic hourly" data frame are only date and temperature.

The selected period is from 13/12/2021 at 00:00:00 to 09/01/22 23:00:00.

The files are bound together by the union() function at every cycle.

REMEMBER to delete the # at the last line of code and change the path and name to get a proper .csv file at the end.

+++++ ONLY in case you need to modify anything read below ++++++

---------- Starting and ending period -----------

What determines the starting period is the date determined by the various url pieces plus the "num1" and "num2" counters.

For example:

url1 <- as.character("https://raw.githubusercontent.com/data-hydenv/data/master/extra/weather/data/2021_12_")

num1 <- as.character("12")

url2 <- as.character("_raw_dump.json")

makes it so that the 

urlt <- paste(url1, num1, url2, sep= "")

yields https://raw.githubusercontent.com/data-hydenv/data/master/extra/weather/data/2021_12_12_raw_dump.json

where the date is 2021_12_12.

So to modify the starting period you have to adjust url1 and num1. Same goes for url3 and num2 regarding January or any months different than the one in url1.

The starting number is 12 and the cycles run further than the 2022-01-09 since the historic data are compiled in such a manner that you need the previous and the next days to get a full "present" day.

That is nothing to worry about, as at the end of the cycles, the data frame is filtered so that it stays within to the desired dates.

It has to be noted that also the while conditions have to be changed in order to keep the cycles running for the desired amount of covered days.

NOTE that as the file for 2021-12-27 is missing, a condition has to setup in order not to get error messages and keep the while machine running.

num1 <- ifelse(num1 == 26, as.integer(num1) + 2, as.integer(num1) + 1)

That means that num1 = 27 is skipped.

To adapt it to a different period you also have to get rid of it in order to get it working properly.

VARIABLES and CODE TO MODIFY in order to make it run on a different period

url1

num1

url3

num2

line 52

line 66

--------- Variables from .json ---------

dttm and th (temperature)

Those are selected from the "historic hourly" dataframe by:

jdf <- js$historic$hourly %>% as.data.frame()

then mutate the date and select just those two:

 dfor <- jdf %>% select(dt, temp)%>% 
    mutate(th = temp) %>% 
    mutate(dttm = as.POSIXct(dt, origin ="1970-01-01")) %>% 
    select(dttm, th)
    
"dfor" is the single dataframe yielded by the current .json file.
    
By modifying jdf one can access to different nested dataframes within the json.

VARIABLES and CODE TO MODIFY to get different variables

jdf

dfor

- Yielded Data Frame -

Before the cycles we create an empty df "dtt".

dtt <- data.frame(dttm =as.Date(character()), th = as.double(double())) 

Every cycle it unites with itself plus "dfor", thus containing every .json desired data.

dtt <- union(dtt, dfor)



