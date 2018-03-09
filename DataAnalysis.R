library(ggplot2)
library(dplyr)
library(wesanderson)

months = as.data.frame(c(rep("Jan", 31*24), rep("Feb", 28*24), rep("Mar", 31*24), rep("April", 30*24), rep("May", 31*24), rep("Jun", 30*24), rep("Jul", 31*24), rep("Aug", 31*24), rep("Sep", 30*24), rep("Oct", 31*24), rep("Nov", 30*24), rep("Dec", 31*24)))
colnames(months) = "months"
months_3 <- rbind(months, months, months)
months3 <- months_3[c(1:26279),1]

heterotrophy <- read.csv("heterotrophy.csv")
heterotropht <- read.csv("heterotropht.csv")
heterotrophy_2 <- cbind(months3, heterotropht/24, heterotrophy)
Name <- as.data.frame(rep("heterotrophic", dim(heterotrophy_2)[1]))
heterotrophy_3 <- bind_cols(Name, heterotrophy_2)
colnames(heterotrophy_3) = c("Type","Month","Day","Nitrogen", "Cells", "Carbon", "Internal.Phosphate", "External.Nitrogen", "External.Phosphate")

spatialy <- read.csv("heterocysty.csv")
spatialt <- read.csv("heterotropht.csv")
spatial_2 <- cbind(months3, spatialt/24, spatialy)
Name2 <- as.data.frame(rep("heterocystous", dim(spatial_2)[1]))
spatial_3 <- bind_cols(Name2, spatial_2)
colnames(spatial_3) <- c("Type","Month", "Day","Nitrogen", "Vegetative", "Heterocysts", "Carbon", "Internal.Phosphate", "External.Phosphate")
spatial_4 <- mutate(spatial_3, Cells = Heterocysts + Vegetative)

temporaly <- read.csv("temporaly.csv")
temporalt <- read.csv("temporalt.csv")
temporal_2 <- cbind(months3, temporalt/24, temporaly)
Name3 <- as.data.frame(rep("circadian", dim(temporal_2)[1]))
temporal_3 <- bind_cols(Name3, temporal_2)
colnames(temporal_3) <- c("Type","Month", "Day","Nitrogen", "Cells", "Carbon", "Internal.Phosphate", "External.Phosphate")

result <- bind_rows(heterotrophy_3, spatial_4, temporal_3)
p <- ggplot(result, aes(Day, Cells, color  = Type))
p+geom_point() + scale_color_manual(values=wes_palette(n=3, name="GrandBudapest"))
