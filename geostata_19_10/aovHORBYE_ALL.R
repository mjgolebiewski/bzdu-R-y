# wykres boxplot dla vnir/swir; analiza wariancji b3n02 + vsnir/swir
# 3.5.4 ze skryptu
# wylicz podstawowoe statystyki dla call/wykresy
# https://bookdown.org/nowosad/Geostatystyka/

library(sp)
library(ggplot2)
library(corrplot)
library(raster)
library(corrplot)
library(car)

call <- read.csv('horbye_all.csv')
str(call)

call_raster <- rasterFromXYZ(xyz = call, res = c(15,15) , crs = NA, digits = 5)
par(mfrow=c(1,1))

plot(call_raster$b3n_01, col = rainbow(30))
plot(call_raster$b3n_02, col = rainbow(30))
plot(call_raster$b3n_04, col = rainbow(30))
plotRGB(call_raster)

coordinates(call) <- ~X+Y
str(call)
call$VNIR <- as.factor(call$VNIR)
call$SWIR <- as.factor(call$SWIR)
str(call)


# h0 - roznica sredniej zmiennej b3n_02 miedzy zmienna czynnikowa 
# promieniowania VNIR wynosi zero (nie jest istotna statystycznie)
# poziom istotnosci = 0.05

aggregate(call@data$b3n_02, list(call@data$VNIR), mean)
boxplot(call@data$b3n_01~call$VNIR)

aov_2_vnir <- aov(lm(b3n_02 ~ VNIR, data = call))
summary(aov_2_vnir)
# 2e-16 < 0.05 - odrzucamy h0 - zmienna czynnikowa VNIR ma wplyw na zmienna b3n_02


# h0 - roznica sredniej zmiennej b3n_02 miedzy zmienna czynnikowa 
# promieniowania SWIR wynosi zero (nie jest istotna statystycznie)
# poziom istotnosci = 0.05

aggregate(call@data$b3n_02, list(call@data$SWIR), mean)
boxplot(call@data$b3n_01~call$SWIR)

aov_2_swir <- aov(lm(b3n_02 ~ SWIR, data = call))
summary(aov_2_swir)
# 2e-16 < 0.05 - odrzucamy h0 - zmienna czynnikowa SWIR ma wplyw na zmienna b3n_02

summary(call)
median(call$b3n_02, na.rm=TRUE) #MEDIANA
mean(call$b3n_02, na.rm=TRUE) #ŚREDNIA
min(call$b3n_02, na.rm=TRUE) #MINIMUM
max(call$b3n_02, na.rm=TRUE) #MAKSIMUM
sd(call$b3n_02, na.rm=TRUE) #ODCHYLENIE STANDARDOWE

table(call$VNIR)
table(call$SWIR)

