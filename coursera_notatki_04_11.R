install.packages('jsonlite')
library(jsonlite)

# xd <- rnorm(100)

# write.csv(xd, file = 'dane_testowe.csv')
# eksport do pliku csv

# dput(xd, file = 'randomowe_dane/dput_test.txt')
# zapisanie pliku jako pliku tekstowego z metadanymi; posiada min. informacje o typach
# danych w kolumnach; podobno lepiej wspopracuje z systemami kontrolii wersji

dx <- dget(file = 'randomowe_dane/dput_test.txt')
# odczytanie danych zapisanych dput

xd <- read.csv('dane_testowe.csv')
# odczytanie danych csv

sapply(xd, class)
# sprawdza typ danych w kazdej kolumnie

head(xd)
str(xd)

url.show(url = 'http://python-data.dr-chuck.net/known_by_Fikret.html')
conurl <- url('http://python-data.dr-chuck.net/known_by_Fikret.html', 'r')
x <- readLines(conurl)
head(x)

con <- file(description = 'randomowe_dane/dput_test.txt', 'r')
zz <- readLines(con, n = 10)
zz

