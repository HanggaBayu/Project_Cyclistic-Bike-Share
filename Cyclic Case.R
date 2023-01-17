save.image("CyclicCase.RData")
savehistory("CyclicCasehistory.Rhistory")

# Import Data and Library

library(tidyverse)
library(ggplot2)
library(janitor)
library(lubridate)
library(dplyr)
library(readr)


Jan22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202201-divvy-tripdata.csv")
Feb22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202202-divvy-tripdata.csv")
Mar22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202203-divvy-tripdata.csv")
Apr22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202204-divvy-tripdata.csv")
Mei22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202205-divvy-tripdata.csv")
Jun22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202206-divvy-tripdata.csv")
Jul22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202207-divvy-tripdata.csv")
Agu22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202208-divvy-tripdata.csv")
Sept22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202209-divvy-tripdata.csv")
Okt22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202210-divvy-tripdata.csv")
Nov22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202211-divvy-tripdata.csv")
Des22 <- read.csv("C:\\Users\\HP\\Jupyter Notebook\\Google Analisis Data (Coursera)\\Studi Kasus Course Final\\Studi Kasus 1 cyclic\\202212-divvy-tripdata.csv")


dtJan22 <- sapply(Jan22,typeof)
dtFeb22 <- sapply(Feb22,typeof)
dtMar22 <- sapply(Mar22,typeof)
dtApr22 <- sapply(Apr22,typeof)
dtMei22 <- sapply(Mei22,typeof)
dtJun22 <- sapply(Jun22,typeof)
dtJul22 <- sapply(Jul22,typeof)
dtAgu22 <- sapply(Agu22,typeof)
dtSept22 <- sapply(Sept22,typeof)
dtOkt22 <- sapply(Okt22,typeof)
dtNov22 <- sapply(Nov22,typeof)
dtDes22 <- sapply(Des22,typeof)

# Data Checking

identical(dtJan22,dtFeb22)
identical(dtFeb22,dtMar22)
identical(dtMar22,dtApr22)
identical(dtApr22,dtMei22)
identical(dtMei22,dtJun22)
identical(dtJun22,dtJul22)
identical(dtJul,dtAgu22)
identical(dtJul22,dtAgu22)
identical(dtAgu22,dtSept22)
identical(dtSept22,dtOkt22)
identical(dtOkt22,dtNov22)
identical(dtNov22,dtDes22)

# Data Cleaning and Conditioning
all_year <- rbind(Jan22,Feb22,Mar22,Apr22,Mei22,Jun22,Jul22,Agu22,Sept22,Okt22,Nov22,Des22)
sum(is.na(all_year))
full_year<-all_year
full_year[full_year == "" | full_year == " "]<- NA
sum(is.na(full_year))
nrow(full_year)
full_year_cleaned<-na.omit(full_year)
sum(is.na(full_year_cleaned))


class(full_year_cleaned$start_station_id)
class(full_year_cleaned$end_station_id)

full_year_cleanedV01<-mutate(full_year_cleaned, start_station_id=as.numeric(start_station_id), end_station_id=as.numeric(end_station_id))

class(full_year_cleanedV01$start_station_id)
class(full_year_cleanedV01$end_station_id)

full_year_cleanedV02<-full_year_cleanedV01%>% select(-c(start_lat,start_lng,end_lat,end_lng))
glimpse(full_year_cleanedV02)
skim_without_charts(full_year_cleanedV02)
View(full_year_cleanedV02)


full_year_cleanedV03<- distinct(full_year_cleanedV02)
full_year_cleanedV03$date<-as.Date(full_year_cleanedV03$started_at)
glimpse(full_year_cleanedV03)

# Data Processing
full_year_cleanedV03$year <- format(as.Date(full_year_cleanedV03$date), "%Y")
full_year_cleanedV03$month <- format(as.Date(full_year_cleanedV03$date), "%m")
full_year_cleanedV03$day <- format(as.Date(full_year_cleanedV03$date), "%d")
full_year_cleanedV03$started_at<-as.Date(full_year_cleanedV03$started_at)
full_year_cleanedV04<-full_year_cleanedV03
full_year_cleanedV04$day_of_week<-format(full_year_cleanedV04$date, "%A")
View(full_year_cleanedV04)
sum(is.na(full_year_cleanedV04))
full_year_cleanedV04<-na.omit(full_year_cleanedV04)
sum(is.na(full_year_cleanedV04))
full_year_cleanedV04$day_of_weeks<-wday(full_year_cleanedV04$date,week_start = 1)

full_year_cleanedV04$ride_length <- difftime(full_year_cleaned_V04$ended_at,full_year_cleaned_V04$started_at)
full_year_cleanedV05<-full_year_cleanedV04
full_year_cleanedV05$started_at <- strptime(paste(full_year_cleanedV05$started_at), format = "%Y-%m-%d %H:%M:%S",tz="UTC") 
glimpse(full_year_cleanedV05)
full_year_cleanedV05$ended_at <- strptime(paste(full_year_cleanedV05$ended), format = "%Y-%m-%d %H:%M:%S",tz="UTC") 
full_year_cleanedV05%>%filter(started_at>ended_at)


full_year_cleanedV05<-full_year_cleanedV05%>%mutate(ride_length = ended_at-started_at)
glimpse(full_year_cleanedV05)
full_year_cleanedV05 <- full_year_cleanedV05 %>%
  filter(ride_length > 0)
glimpse(full_year_cleanedV05)

# Data Analyzing
mean(full_year_cleanedV05$ride_length)
median(full_year_cleanedV05$ride_length)
max(full_year_cleanedV05$ride_length)
min(full_year_cleanedV05$ride_length)

full_year_cleanedV06 <- full_year_cleanedV05[!(full_year_cleanedV05$ride_length>86400),]
mean(full_year_cleanedV06$ride_length)
median(full_year_cleanedV06$ride_length)
max(full_year_cleanedV06$ride_length)
min(full_year_cleanedV06$ride_length)

aggregate(full_year_cleanedV06$ride_length ~ full_year_cleanedV06$member_casual, FUN = mean)
aggregate(full_year_cleanedV06$ride_length ~ full_year_cleanedV06$member_casual, FUN = median)
aggregate(full_year_cleanedV06$ride_length ~ full_year_cleanedV06$member_casual, FUN = max)
aggregate(full_year_cleanedV06$ride_length ~ full_year_cleanedV06$member_casual, FUN = min)
aggregate(full_year_cleanedV06$ride_length ~ full_year_cleanedV06$member_casual + full_year_cleanedV06$day_of_week, FUN = mean)

full_year_cleanedV06$day_of_week <- ordered(full_year_cleanedV06$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
aggregate(full_year_cleanedV06$ride_length ~ full_year_cleanedV06$member_casual + full_year_cleanedV06$day_of_week, FUN = mean)

full_year_cleanedV07<-full_year_cleanedV06

full_year_cleanedV07 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length/60)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)	

# Vizualization

# Number of rides
full_year_cleanedV07 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

#Average Duration
full_year_cleanedV07 %>%
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

table(full_year_cleanedV07$member_casual)

# Customer Type
ggplot(data=full_year_cleanedV07)+
  geom_bar(mapping=aes(x="",fill=member_casual))+
  coord_polar("y")+
  annotate("text",label="Member",x=1,y=200000,size=6)+
  annotate("text",label="554618",x=1,y=250000,size=6)+
  annotate("text",label="54 %",x=1,y=300000,size=6)+
  annotate("text",label="Casual",x=1,y=820000,size=6)+
  annotate("text",label="474112",x=1,y=770000,size=6)+
  annotate("text",label="46%",x=1,y=720000,size=6)+
  theme(plot.background=element_blank(),
        panel.background=element_blank(),
        axis.title=element_blank(),
        axis.ticks=element_blank(),
        axis.text=element_blank(),
        legend.position="none")+
  ggtitle(label="Number of Rides from Each Customer Type",
          subtitle="Source: Cyclistic")

# Number of rides in month
full_year_cleanedV07 %>%
  mutate(month = month(started_at, label = TRUE)) %>%
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, month) %>%
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# line Chart number of rides
full_year_cleanedV07 %>%
  mutate(month = month(started_at, label = TRUE)) %>%
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, month) %>%
  ggplot(aes(x = month, y = number_of_rides, group= member_casual)) +
    geom_line(aes(color=member_casual))+
    geom_point()

# Line Chart Average Duration
full_year_cleanedV07 %>%
  mutate(month = month(started_at, label = TRUE)) %>%
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%
  arrange(member_casual, month) %>%
  ggplot(aes(x = month, y = average_duration, group= member_casual)) +
    geom_line(aes(color=member_casual))+
    geom_point()
