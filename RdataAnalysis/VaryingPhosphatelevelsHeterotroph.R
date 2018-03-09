# Phosphate Reduction

phosphatevery_low <- read.csv("VL_P_troph.csv")
phosphatelow <- read.csv("H_P_troph.csv")
phosphatemed <- read.csv("M_P_troph.csv")
phosphatehigh <- read.csv("L_P_troph.csv")

identifier <- as.data.frame(rep("high", 3*365*24-1))
identifier2 <- as.data.frame(rep("med", 3*365*24-1))
identifier3 <- as.data.frame(rep("low", 3*365*24-1))
identifier4 <- as.data.frame(rep("very_low", 3*365*24-1))

day = as.data.frame(1:(3*365*24-1))


phosphatevery_low2 <- bind_cols(day/24,identifier4, phosphatevery_low)
phosphatelow2 <- bind_cols(day/24,identifier, phosphatelow)
phosphatemed2 <- bind_cols(day/24,identifier2, phosphatemed)
phosphatehigh2 <- bind_cols(day/24,identifier3, phosphatehigh)


colnames(phosphatelow2) = c("Day","P.Level", "Nitrogen", "Cells", "Carbon", "Phosphate", "External.Phosphate", "External.Nitrogen")
colnames(phosphatemed2) = c("Day","P.Level", "Nitrogen", "Cells", "Carbon", "Phosphate", "External.Phosphate", "External.Nitrogen")
colnames(phosphatehigh2) = c("Day" ,"P.Level", "Nitrogen", "Cells", "Carbon", "Phosphate", "External.Phosphate", "External.Nitrogen")
colnames(phosphatevery_low2) = c("Day","P.Level", "Nitrogen", "Cells", "Carbon", "Phosphate", "External.Phosphate", "External.Nitrogen")


result <- bind_rows(phosphatehigh2, phosphatemed2, phosphatelow2, phosphatevery_low2)

p <- ggplot(result, aes(Day, Cells, color  = P.Level))
p+geom_point() + scale_color_manual(values=wes_palette(n=4, name="GrandBudapest")) + ggtitle("Hetertrophic Cells' Dependence on External Phosphate")

