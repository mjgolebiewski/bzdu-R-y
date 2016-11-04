#####
## wykonaj interpolacje 
# zapisz na jednym slajdzie (poszukaj jak zrobic 3)
# do 5 interpolacji dodaj punkty (horbey_probka)
# dodaj tez populacje horbey_all
#####

# 26_10 interpolacje i horbye

# install.packages('fields')
# library(fields)

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

# wczytanie danych csv i zamiana na spatialPointDF
horbye <- read.csv(file = 'geostata_26_10/horbye_proba.csv')
coordinates(horbye) <- ~X + Y

horbyeALL <- read.csv(file = 'geostata_26_10/horbye_all.csv')
coordinates(horbyeALL) <- ~X + Y


## tworzenie siatek 
# expand.grid - kazda wartosc X z kazda wartoscia Y
# tworzenie obiektu przestrzennego 
# gridded - potraktuj obiekt jako siatke

siatka <- expand.grid(x = seq(from = -15, to = 1275, by = 15),
                      y = seq(from = -15, to = 1065, by = 15))

coordinates(siatka) <- ~x + y

gridded(siatka) <- TRUE

plot(siatka, add = TRUE)
plot(horbye, add = TRUE)


# zbior wartosci bez NA (wykrzyknik daje zaprzeczenie)
horbye_2 <- horbye[!is.na(horbye$b3n_02),]
horbyeALL_2 <- horbyeALL[!is.na(horbyeALL$b3n_02),]
plot(horbyeALL_2)
plot(horbye_2)

lista <- list(horbye_2, horbyeALL_2)
# interpolacja voronoia
voronoi_interp <- voronoi(horbye_2)
# voronoi_interp <- intersect(horbye, voronoi_interp)
spplot(voronoi_interp, 'b3n_02', contour = TRUE, main='Poligony Voronoia', sp.lines = horbyeALL_2)
spplot(voronoi_interp, 'b3n_02', contour = TRUE, main='Poligony Voronoia', sp.layout = horbye_2)


# idw - srednia wazona odlegloscia
idw_horbye <- idw(b3n_02~1, horbye_2, siatka, idp=2)
plot(idw_horbye)

spplot(idw_horbye, 'var1.pred', contour = TRUE, main='IDW xD', sp.layout = horbyeALL_2)

# funkcje wielomianowe
wielomian_1 <- gstat(formula = b3n_02~1, data = horbye_2, degree = 1)
wielomian_2 <- gstat(formula = b3n_02~1, data = horbye_2, degree = 2)
wielomian_3 <- gstat(formula = b3n_02~1, data = horbye_2, degree = 3)

wmn_1_pred <- predict(object = wielomian_1, newdata = siatka)
wmn_2_pred <- predict(object = wielomian_2, newdata = siatka)
wmn_3_pred <- predict(object = wielomian_3, newdata = siatka)

spplot(wmn_1_pred[1], contour = TRUE, main = 'Pow. trendu - wielomian 1szego stopnia', sp.layout = horbye_2)
spplot(wmn_2_pred[1], contour = TRUE, main = 'Pow. trendu - wielomian 2giego stopnia', sp.layout = horbye_2)
spplot(wmn_3_pred[1], contour = TRUE, main = 'Pow. trendu - wielomian 3ciego stopnia', sp.layout = horbye_2)


# funkcje deterministyczne
# to nie dziala, nie wiem ocb

# tps <- Tps(coordinates(horbye), punkty@data$temp)
# ras <- raster(siatka)
# spline <- interpolate(ras, horbye)
# spline <- mask(spline, ras)
# spplot(spline, contour=TRUE , main='Funkcje sklejane')

