# library(rasterVis)
# library(rgdal)
library(sp)
library(ggplot2)
library(corrplot)
library(raster)
library(corrplot)

call <- read.csv('geostata_19_10/horbye_all.csv')
csam <- read.csv('geostata_19_10/horbye_proba.csv')

str(csam)
summary(csam)

# plot(csam$b3n_02)
# plot(csam$b3n_04)
# plot(csam$b3n_01)

coordinates(csam) <- ~X+Y
str(csam)

plot(csam)

call_raster <- rasterFromXYZ(xyz = call, res = c(15,15) , crs = NA, digits = 5)
# plotRGB(call_raster) - to dziala jak cos

# nie wiem co to robi, sprawdz
par(mfrow=c(1,1))

plot(call_raster$b3n_01, col = rainbow(30))
plot(call_raster$b3n_02, col = rainbow(30))
plot(call_raster$b3n_04, col = rainbow(30))

plot(csam, add=TRUE)

str(csam@data)

# ilosc klas
sort(unique(csam$VNIR))
sort(unique(csam$SWIR))

# transformacja do zmiennej jakosciowej
csam$VNIR <- as.factor(csam$VNIR)
csam$SWIR <- as.factor(csam$SWIR)
str(csam@data)

str(csam@data$b3n_02)
str(csam@data$b3n_04)
str(csam@data$b3n_01)


# statystyki opisowe
summary(csam)

# mediana/srednia/min/max
median(csam$b3n_02, na.rm = TRUE)
mean(csam$b3n_02, na.rm = TRUE)
min(csam$b3n_02, na.rm = TRUE)
max(csam$b3n_02, na.rm = TRUE)

# odchylenie standardowe
sd(csam$b3n_02, na.rm = TRUE)

# dane jakosciowe w tabeli sie przedstawia xd
table(csam$VNIR)
table(csam$SWIR)

# histogram
ggplot(csam@data, aes(b3n_02)) + geom_histogram()

# estymator jadrowy gestosci
ggplot(csam@data, aes(b3n_02)) + geom_density()

# wektor kwantyl/kwantyl
ggplot(csam@data, aes(sample=b3n_02)) + stat_qq()

# dystrybuanta
ggplot(csam@data, aes(b3n_02)) + stat_ecdf()

# k o w a r i a n c j a (liniowe to jest)
cov(csam$b3n_02, csam$b3n_04, use = "complete.obs")

# wspolczynnik korelacji (od -1do1; zaleznosc liniowa)
#   wykres rozrzutu
ggplot(data = csam@data, aes(b3n_02, b3n_04)) + geom_point()

#   wpolczynnik korelacji
cor(csam$b3n_02, csam$b3n_04, use = "complete.obs")

#   istotnosc korelacji
cor.test(csam$b3n_02, csam$b3n_04, use = "complete.obs")


# wykresiki jakies
csam_komp <- csam[complete.cases(csam$b3n_02, csam$b3n_04), ]
corrplot(cor(csam_komp@data[c(1,2,3)]))

# boxploty
ggplot(data = csam@data, aes(VNIR, b3n_02))+geom_boxplot()

# wykres boxplot dla vnir/swir; analiza wariancji b3n02 + vsnir/swir
# 3.5.4 ze skryptu
# wylicz podstawowoe statystyki dla call/wykresy

str(call)
ggplot(data = call@data, aes(VNIR, swir))+geom_boxplot()


# boxplot VNIR/SWIR
ggplot(data = csam@data, aes(SWIR, b3n_02))+geom_boxplot()
ggplot(data = csam@data, aes(VNIR, b3n_02))+geom_boxplot()

#zalozenia
# 1. liczebnosc 
# 2. rownolicznosc 
# 3. rozklad normalny 
#h0(do testu shaphiro-wilka) dane sa zgodne z rozkladem normalnym
# poziom istotnosci = 0.05


str(call$VNIR)
str(call$SWIR)
str(call$b3n_02)

aov_test()