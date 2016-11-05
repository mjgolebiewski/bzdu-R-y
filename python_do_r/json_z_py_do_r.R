# https://google.github.io/styleguide/Rguide.xml
# dlaczego jeszcze nie ma addina ktory to sprawdza? cos jak te standardy
# do pythona, pep8 i w ogole

"
Extracting Data from JSON

In this assignment you will write a Python program somewhat similar to
http://www.pythonlearn.com/code/json2.py. The program will prompt for a URL,
read the JSON data from that URL using urllib and then parse and extract the
comment counts from the JSON data, compute the sum of the numbers in the file
and enter the sum below:
"

# import urllib
# import json

# dobry_link = 'http://python-data.dr-chuck.net/comments_302554.json'

# czytaj_url = urllib.urlopen(dobry_link)
# print 'pozyskuje dane z linku:', dobry_link

# do_jsn = json.load(czytaj_url)
# zliczenia = 0
# for elem in do_jsn['comments']:
#     zliczenia += elem['count']
# print 'suma wynikow:', zliczenia

# nie wiem po co lib curl jest potrzebne ale jsonlite nie chcial bez tego dzialac
# generalnie to przepisalem jeden z assignmentow z pythona do R, pewnie nie jest
# jeszcze wystarczajaco r-(py)-thonic ale dziala okej?
install.packages('curl')
install.packages('jsonlite')
library(jsonlite)
library(curl)

wczytanieLinku <- function() {
  n <- readline(prompt = "wpisz link do jsona: ")
  ng <- fromJSON(n)
  return(ng)
}    

sumowanko <- function() {
  ling <- wczytanieLinku()
  print(toJSON(ling, pretty = TRUE))
  print(as.integer(sum(ling$comments$count)))
}

# link do testow:
# http://python-data.dr-chuck.net/comments_302554.json
sumowanko()

