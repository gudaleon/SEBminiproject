# Phosphate Reduction

nitrogenlow <- read.csv("H_N_troph.csv")
nitrogenmed <- read.csv("M_N_troph.csv")
nitrogenhigh <- read.csv("L_N_troph.csv")

nitrogenhigh = nitrogenhigh[c(1:(365*24-1)),c(1:6)]

identifier <- as.data.frame(rep("high", 365*24-1))
identifier2 <- as.data.frame(rep("med", 365*24-1))
identifier3 <- as.data.frame(rep("low", 365*24-1))

day = as.data.frame(1:(365*24-1))


nitrogenlow2 <- bind_cols(day/24,identifier, nitrogenlow)
nitrogenmed2 <- bind_cols(day/24,identifier2, nitrogenmed)
nitrogenhigh2 <- bind_cols(day/24,identifier3, nitrogenhigh)


colnames(nitrogenlow2) = c("Day","N.Level", "Nitrogen", "Cells", "Carbon", "Phosphate", "External.Phosphate", "External.Nitrogen")
colnames(nitrogenmed2) = c("Day","N.Level", "Nitrogen", "Cells", "Carbon", "Phosphate", "External.Phosphate", "External.Nitrogen")
colnames(nitrogenhigh2) = c("Day" ,"N.Level", "Nitrogen", "Cells", "Carbon", "Phosphate", "External.Phosphate", "External.Nitrogen")

resultN <- bind_rows(nitrogenhigh2, nitrogenmed2, nitrogenlow2)

pN <- ggplot(resultN, aes(Day, Cells, color  = N.Level))
pN+geom_point() + scale_color_manual(values=wes_palette(n=3, name="GrandBudapest")) + ggtitle("Hetertrophic Cells' Dependence on External Nitrogen")

