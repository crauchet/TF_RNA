# Create a timeline of plot of TF-RNA Publications

# Goal is to convey what Transcription Factors have been studied over time recently
# Also, show the publications that I will be working with for the presentation


### SET VARIABLES FOR DF

day <- c(9, 1, 6, 14, 16, 14, 16, 29, 9, 25, 27, 20, 3 )
month <- c(7, 3, 6, 4, 7, 10, 9, 10, 6, 2, 5, 7, 10   )
year <- c(2025, 2026, 2024, 2020, 2024, 2022, 2024, 2025, 2023, 2025, 2025, 2023, 2024 )
tf <- c("MYC", "MYC", "MYCN", "Sox2", "ER and Sox2", "ER", "ER", "ER", "GR", "GATA1", "E2F1", "Integrative", "C2H2" )
title <-c("Integrative characterization of MYC RNA-binding function", 
          "MYC binding to nascent RNA suppresses innate immune signaling by R-loop-derived RNA-DNA hybrids", 
          "The MYCN oncoprotein is an RNA-binding accessory factor of the nuclear exosome targeting complex", 
          "The Sox2 transcription factor binds RNA", 
          "Transcription factors ERα and Sox2 have differing multiphasic DNA- and RNA-binding mechanisms", 
          "An Extended DNA Binding Domain of the Estrogen Receptor Alpha Directly Interacts with RNAs in Vitro", 
          "RNA fine-tunes estrogen receptor-alpha binding on low-affinity DNA motifs for transcriptional regulation", 
          "Paused RNA polymerase primes promoters via RNA-mediated stabilisation of transcription factor ERα", 
          "RNA binding by the glucocorticoid receptor attenuates dexamethasone-induced gene activation", 
          "A Distinct Mechanism of RNA Recognition by the Transcription Factor GATA1",
          "LncRNA SLNCR phenocopies the E2F1 DNA binding site to promote melanoma progression",
          "Transcription factors interact with RNA to regulate genes",
          "C2H2-zinc-finger transcription factors bind RNA and function in diverse post-transcriptional regulatory processes"
            )
author <-c("Li, et.al", "Uhl, et.al", "Papadopolous, et.al", "Holmes and Hamilton, et.al", 
           "Hemphill, Steiner, Kominsky, et.al", "Steiner, et. al", "Soota, et.al", "Mann, et.al", "Lammer, et.al", "Ugay, et.al",
           "Shah, et.al", "Oksuz, et.al", "Nabeel-Shah, et.al"
           )
### Create Data Frame from Variables 

publications_df <- data.frame(Day = day, Month = month, Year = year, TF = tf, Title = title, Author = author)

### Now we will modify the dataframe so that we can create a new colummn with a usable date

library(ggplot2)
library(scales)
library(lubridate)


# Add the date column to the table at the end of the row
# This uses the lubridate package to create a date formated object

publications_df$date <- with(publications_df, ymd(sprintf('%04d%02d%02d', year, month, day)))
publications_df <- publications_df[with(publications_df, order(date)), ]
head(publications_df)

# Generate a list of positions for the height on the graph to avoid overlapping positions in ggplot
#This will be used to place the location of each geom_text of the TF names in the y direction

positions <- c(0.5, -0.5, 1.0, -1.0, 1.5, -1.5)

#Directions are either up or down (might not actually need this, but just in case we need to sperate later)
directions <- c(1, -1)

#Replicate elements of the vector positions, for the length of the publications_df column and make a new df
#Keep the date column the same becauce we will merge by that column soon

line_pos <- data.frame(
  "date"=unique(publications_df$date),
  "position"=rep(positions, length.out=length(unique(publications_df$date))),
  "direction"=rep(directions, length.out=length(unique(publications_df$date)))
)
# Take the line position and merge with publications to make a new df for ggplot to use

df <- merge(x=publications_df, y=line_pos, by="date", all = TRUE)

timeline <- ggplot(df, aes(x=date, y=0))
timeline

# Make theme classic

timeline_classic <- timeline + theme_classic()
timeline_classic

# Add the horizontal line that makes up the timeline

timeline_line <- timeline_classic +  geom_hline(yintercept=0, 
                              color = "black", linewidth=0.4)
timeline_line

#Add the segments that form the heights of the TFs in date space
# To make the TF height be position, need the line segment to be shorter to avoid overlap
# Multiply them by 0.9

timeline_segments <- timeline_line + geom_segment(data=df, aes(y=position*0.85,yend=0,xend=date), color='black', size=0.2)
timeline_segments

#Clear the formating of the line segments
timeline_format <- timeline_segments + theme(axis.line.y=element_blank(),
                                             axis.text.y=element_blank(),
                                             axis.title.x=element_blank(),
                                             axis.title.y=element_blank(),
                                             axis.ticks.y=element_blank(),
                                             axis.text.x =element_blank(),
                                             axis.ticks.x =element_blank(),
                                             axis.line.x =element_blank(),
                                             legend.position = "none")

timeline_format

#Add labels of the TF, including color and a density point that hits the timeline

timeline_TF <- timeline_format + geom_point(aes(y = 0, color = TF), size = 2) +
  geom_text(aes(y = position, label = TF, color = TF), check_overlap = TRUE)
timeline_TF

#Add markers for the years
#To do so, make a data  frame with the first day of each year

#Use the lubridate command (ymd) to make it into a functional date format
year_df=data.frame(day=c(1,1,1,1,1,1,1), 
                   month=c(1,1,1,1,1,1,1), 
                   year=c(2020, 2021, 2022, 2023, 2024, 2025, 2026))
year_df$date <- with(year_df, ymd(sprintf('%04d%02d%02d', year, month, day)))
#We have added the date column to this so it will be compatible withe the date line graph function
year_df


timeline_years <- timeline_TF + geom_text(data=year_df, aes(x=date, y=-0.13, label = year), check_overlap = TRUE)
timeline_years

#Now let's add the tick marks to the figure at the start of each year


timeline_tickmark <- timeline_years + geom_segment(data=year_df, aes(x=date, yend = -0.05), color='black', size=0.2)
timeline_tickmark



timeline_labeled <- timeline_tickmark + labs(title = "Publications of TF-RNA Interactions 2020-2026")
timeline_labeled







