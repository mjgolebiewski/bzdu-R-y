# pakiety <- c('fields', 'jsonlite', 'caret', 'corrplot', 'dismo', 'fields',
#              'ggplot2', 'gridExtra', 'gstat', 'pgirmess', 'raster',
#              'rasterVis', 'rgdal', 'rgeos', 'sp', 'faker')
# install.packages(pakiety)


library(fakeR)
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
library(fields)


x <- jsonlite::fromJSON('randomowe_dane/MOCK_DATA.json')
x$Y <- rnorm(1000, mean = 500000, sd = 75000)
x$X <- rnorm(1000, mean = 500000, sd = 75000)
x$division <- as.factor(state.division)
x$gender <- as.factor(x$gender)
x <- na.omit(x)
sapply(x, class)
str(x)
# View(x)

coordinates(x) <- ~X+Y
spplot(x, 'gender')
spplot(x, 'division')

x$id <- 1:nrow(x)
spplot(x, 'id', colorkey=TRUE)

siatka <- expand.grid(x = seq(from = x@bbox[1,1]+10000, to = x@bbox[1,2]+10000, by = 75000),
                      y = seq(from = x@bbox[2,1]+10000, to = x@bbox[2,2]+10000, by = 75000))
coordinates(siatka) <- ~x + y
gridded(siatka) <- TRUE
plot(siatka)
plot(x, add = TRUE)

# spplot(obj = x, 'division', sp.layout = siatka)
