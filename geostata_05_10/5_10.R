# skrypt nowosada
# https://bookdown.org/nowosad/Geostatystyka/

pakiety <- c('caret', 'corrplot', 'dismo', 'fields', 'ggplot2', 'gridExtra',
             'gstat', 'pgirmess', 'raster', 'rasterVis', 'rgdal', 'rgeos', 'sp')
install.packages(pakiety)


c <- read.csv('geostata_05_10/opady_malopolskie.csv')
library(sp)
library(rgdal)
library(raster)
library(rasterVis)

# podglad danych
head(c)
summary(c)

# struktura danych
str(c)

# przeksztalcenie danych do danych przestrzennych
# data frame -> SpatialPointDataFrame
# nadanie wspolrzednych - funkcja coordinates() z pakietu sp
coordinates(c) <- ~X92+Y92

summary(c)
str(c)

# dodanie informacji o uk przestrzennym danych
proj4string(c) <- '+init=epsg:2180'

summary(c)


c@data$I
c$I
# wyswietlanie informacji o zasiegu danych
c@bbox 
# info o ukladnie wspolrzednych
c@proj4string

# wyswietlanie danych przestrzennych (proste)
plot(c)


# WCZYTYWANIE DANYCH POLIGONOWYCH (SHP)
g <- readOGR(dsn='geostata_05_10/malopolskie', layer='malopolskie')

str(g)
plot(g)


# WCZYTYWANIE DANYCH RASTROWYCH
tt <- raster('geostata_05_10/clc.tif')
plot(tt)



# zapis danych
# wektorowych
writeOGR(obj = c, dsn = 'geostata_05_10/opady_shp', layer = "c", driver = 'ESRI Shapefile')

# rastrowych
writeRaster(x = tt, filename = 'geostata_05_10/tt.tif')


# rozklad opadow stycznia
spplot(obj = c, 'I')

# rozklad opadow lipca
spplot(obj = c, 'VII')

# tworzenie siatek






