install.packages('dismo')
install.packages('gstat')

library(sp)
library(ggplot2)
library(corrplot)
library(raster)
library(corrplot)
library(car)
library(rgdal)
library(raster)
library(rasterVis)
library(dismo)
library(gstat)

# wczytanie jako csv
horbye <- read.csv(file = 'geostata_26_10/horbye_proba.csv')
horbye3a <- read.csv(file = 'geostata_26_10/horbye_3a.csv')
horbye3b <- read.csv(file = 'geostata_26_10/horbye_3b.csv')

# struktura pliku (do zczytania zmiennych odpowiadajacych za wspolrzedne: 
# tutaj X i Y)
str(horbye)
str(horbye3a)
str(horbye3b)

# transformacja do spatialPointDF
coordinates(horbye) <- ~X+Y
coordinates(horbye3a) <- ~X+Y
coordinates(horbye3b) <- ~X+Y

# raster jako csv
horbye_all <- read.csv(file = 'geostata_26_10/horbye_all.csv')

# raster jako obrazeg
call_raster <- rasterFromXYZ(xyz = horbye_all, res = c(15,15) , crs = NA, digits = 5)

str(horbye_all)
plotRGB(call_raster)



g <- readOGR(dsn='geostata_26_10/horbye_granica', layer='horbye_granica')
str(g)
plot(g)

# typy probkowania
set.seed(255)
# regularne
reg <- spsample(x = g, n = 257, type = 'regular')
plot(x = reg, pch = 20)
plot(g, add = TRUE)

# przypadkowe
ran <- spsample(x = g, n = 257, type = 'random')
plot(x = ran, pch = 20)
plot(g, add = TRUE)

# stratyfikowane
stra <- spsample(x = g, n = 257, type = 'stratified')
plot(x = stra, pch = 20)
plot(g, add = TRUE)

# preferencyjne
set.seed(425)
pref <- spsample(x = g, n = 257, type = 'clustered', nclusters=30)
plot(x = pref, pch = 20)
plot(g, add = TRUE)


# dane lokalnie odstajace
spplot(obj = horbye, 'b3n_02', sp.layout = g)
# w powyzszym plocie widac lokalnie odstajaca wartosc (rzulta plama)

spplot(obj = horbye3a, 'b3n_02', sp.layout = g)
# tutaj sa punkty poza obszarem badan (blad)
# bledne wartosci wykluczamy z analizy

spplot(obj = horbye3b, 'b3n_02', sp.layout = g)
# wartosc minimalna i maksymalna 
# sa tuz obok siebie (najprawdopodobniej blad)
# bledne wartosci wykluczamy z analizy


### metody interpolacji

## tworzenie siatek 
# expand.grid - kazda wartosc X z kazda wartoscia Y
# tworzenie obiektu przestrzennego 
# gridded - potraktuj obiekt jako siatke

siatka <- expand.grid(x = seq(from = -15, to = 1275, by = 15),
           y = seq(from = -15, to = 1065, by = 15))

coordinates(siatka) <- ~x + y

gridded(siatka) <- TRUE
plot(horbye)
plot(siatka, add = TRUE)

# zbior wartosci bez NA (wykrzyknik daje zaprzeczenie)
horbye_2 <- horbye[!is.na(horbye$b3n_02),]

# interpolacja voronoia
voronoi_interp <- voronoi(horbye_2)
plot(voronoi_interp)

spplot(voronoi_interp, 'b3n_02', contour = TRUE, main='Poligony Voronoia')


# idw - srednia wazona odlegloscia
idw_horbye <- idw(b3n_02~1, horbye_2, siatka, idp=2)
plot(idw_horbye)

spplot(idw_horbye, 'var1.pred', contour = TRUE, main='IDW xD')


# funkcje wielomianowe
wielomian_1 <- gstat(formula = b3n_02~1, data = horbye_2, degree = 1)
wielomian_2 <- gstat(formula = b3n_02~1, data = horbye_2, degree = 2)
wielomian_3 <- gstat(formula = b3n_02~1, data = horbye_2, degree = 3)

wmn_1_pred <- predict(object = wielomian_1, newdata = siatka)
wmn_2_pred <- predict(object = wielomian_2, newdata = siatka)
wmn_3_pred <- predict(object = wielomian_3, newdata = siatka)

spplot(wmn_1_pred[1], contour = TRUE, main = 'Pow. trendu - wielomian 1szego stopnia')
spplot(wmn_2_pred[1], contour = TRUE, main = 'Pow. trendu - wielomian 2giego stopnia')
spplot(wmn_3_pred[1], contour = TRUE, main = 'Pow. trendu - wielomian 3ciego stopnia')


#####
## wykonaj interpolacje 
# zapisz na jednym slajdzie (poszukaj jak zrobic 3)
# do 5 interpolacji dodaj punkty (horbey_probka)
# dodaj tez populacje horbey_all

