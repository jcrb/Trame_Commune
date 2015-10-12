# Logos
jcb  
12 septembre 2015  

Logos pour la cartographie
==========================

Dossier Trame_Commune/Logos

Les logos sont préférentiellement au format .png

source: 

- ambulances: http://www.flaticon.com/free-icons/ambulance_225
- hélicos: http://www.flaticon.com/search/helicopters
- hospitals: http://www.flaticon.com/free-icon/hospital-buildings_33777
- SAMI, SDIS: http://www.flaticon.com/free-icon/male-telemarketer_81523
- déconta: http://www.flaticon.com/free-icon/man-showering_76657
- sang: http://www.flaticon.com/free-icon/blood-perfusion_69691

Licence: Icon made by [Freepick](http://www.flaticon.com/authors/freepik) from www.flaticon.com 

Le dossier __Logos/data__ contient un certain nombre d'images à difféents niveaux de résolution:

- ambulance15
- shopper5 (hélicoptère)
- hospital11
- man253 (douche mobile)
- men39 (douche fixe)
- perfusion
- transport51 (ambulance)

Afficher une image PNG dans un graphe
-------------------------------------

- source: http://stackoverflow.com/questions/4975681/r-creating-graphs-where-the-nodes-are-images
- source: https://ryouready.wordpress.com/2014/09/12/using-colorized-png-pictograms-in-r-base-plots/
```{}
library(png)
img <- readPNG(system.file("img", "Rlogo.png", package="png"))
# une zone graphique
plot(c(100, 250), c(300, 450), type = "n", xlab = "", ylab = "")

rasterImage(img, 150, 300, 200, 350, interpolate = TRUE)
rasterImage(img, 100, 400, 110, 410, angle = 90, interpolate = TRUE)

file <- "rat.png"
rat <- readPNG(file)
rasterImage(rat, 100, 400, 134, 428, interpolate = TRUE)

```

Ambulance
---------


```r
library(png)
# amb <- readPNG("Logos/data/transport51(8).png")
amb <- readPNG("data/transport51(8).png")
class(amb)
```

```
## [1] "array"
```

```r
dim(amb)
```

```
## [1] 64 64  4
```
L'objet __amb__ est un tableau numérique de 64 lignes et 64 colonnes avec quatre couches (red, green, blue, alpha; short RGBA).

Let’s have a look at the first layer (red) and replace all non-zero entries by a one and the zeros by a dot. This will show us the pattern of non-zero values and we already see the contours.


```r
l4 <- amb[,,1]
l4[l4 > 0] <- 1
l4[l4 == 0] <- "."
d <- apply(l4, 1, function(x) {
 cat(paste0(x, collapse=""), "\n") 
})
```

```
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## .....................11......................................... 
## .....................11......................................... 
## .....................11......................................... 
## ...............111...11...11.................................... 
## ...............1111......111.................................... 
## ................111.111.111..................................... 
## ....................1111........................................ 
## ....................1111........................................ 
## ....................1111........................................ 
## ................................................................ 
## ...............1111111111111111111111111111111111111111111111111 
## .............111111111111111111111111111111111111111111111111111 
## ............1111.......11111111111111111111111111111111111111111 
## ...........11111.......11111111111111111111111111111111111111111 
## ..........11111........11111111111111111111111111111111111111111 
## ..........1111.........11111111111111111111111111111111111111111 
## .........1111..........11111111111111111111.11111111111111111111 
## ........1111...........11111111111111111111.11111111111111111111 
## .......1111............11111111111111111111.11111111111111111111 
## ......1111.............11111111111111111111.11111111111111111111 
## ......111..............1111111111111111.........1111111111111111 
## ....11111111111111111111111111111111111.........1111111111111111 
## ...1111111111111111111111111111111111111111.11111111111111111111 
## .111111111111111111111111111111111111111111.11111111111111111111 
## 1111111111111111111111111111111111111111111.11111111111111111111 
## 1111111111111111111111111111111111111111111.11111111111111111111 
## 1111111111111111111111111111111111111111111111111111111111111111 
## 1111111111111111111111111111111111111111111111111111111111111111 
## 1111111111111111111111111111111111111111111111111111111111111111 
## 11111111111111111111111111111111111111111111111111111111111111.1 
## 111111111...11111111111111111111111111111111111111...111111111.1 
## 1111111.......111111111111111111111111111111111........1111111.1 
## 111111.1111111..111111111111111111111111111111..111111..111111.1 
## 11111.111111111.111111111111111111111111111111.111111111.1111111 
## 1111..111111111..1111111111111111111111111111.1111111111.1111111 
## 1111.11111111111.1111111111111111111111111111.1111111111..111111 
## 1111.11111111111.1111111111111111111111111111.11111111111.111111 
## .....11111111111..............................11111111111....... 
## .....11111111111..............................1111111111........ 
## ......111111111................................111111111........ 
## ......111111111................................11111111......... 
## ........111111..................................111111.......... 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................ 
## ................................................................
```
To display the image in R one way is to raster the image (i.e. the RGBA layers are collapsed into a layer of single HEX value) and print it using rasterImage.


```r
rimg <- as.raster(amb) # raster multilayer object
r <- nrow(rimg) / ncol(rimg) # image ratio
plot(c(0,10), c(0,10), type = "n", xlab = "", ylab = "", asp=1) # une zone graphique vide
rasterImage(rimg, 0, 0, 1, r) # img, x1, y1, x2, y2
rasterImage(rimg, 5, 2, 6, 3)

smur <- as.raster(readPNG("data/ambulance15(14).png"))
rasterImage(smur, 4, 2, 5, 3)
rasterImage(smur, 6, 4, 8, 6)
```

![](logos_files/figure-html/unnamed-chunk-3-1.png) 

Essai de CArto
==============


```r
library(sp)
par(mar = c(0,0,2,0))

# carte de l'Alsace avec les villes sièges de SU
load("../../../Stat Resural/RPU_Doc/RPU_Carto-Pop-Alsace/Cartographie/Cartofile/als_ts.Rda") #ctss
 plot(ctss, main = "SAMU et SMUR en Alsace")
 load("../../../Stat Resural/RPU_Doc/RPU_Carto-Pop-Alsace/Cartographie/Cartofile/tsvilles.Rda")
 points(tsvilles[,2]*100,tsvilles[,3]*100,pch=20,col="red", cex = 1.2)
 text(tsvilles[,2]*100,tsvilles[,3]*100,tsvilles[,1],cex=0.8,pos=4)
box()

# SMUR
smur <- tsvilles[tsvilles$NOM %in% c('WISSEMBOURG','HAGUENAU','SAVERNE','STRASBOURG','SELESTAT','COLMAR','MULHOUSE'),]
a.smur <- as.raster(readPNG("data/ambulance15(14).png"))
cx <- 6000 # coefficient d'aggrandissement (n = 9000)
x <- smur[,2]*100
y <- smur[,3]*100
dy <- 600 # déplacement de y (une valeur positive déplace vers le haut)
dx <- 0 # déplacement horizontal
rasterImage(a.smur, x, y + dy, x + cx, y + dy + cx) # img, x1, y1, x2, y2

# SAMU
samu <- tsvilles[tsvilles$NOM %in% c('STRASBOURG', 'MULHOUSE'),]
a.samu <- as.raster(readPNG("data/customer(3).png"))
rasterImage(a.samu, samu[,2]*100 - 10000, samu[,3]*100, samu[,2]*100 - 10000 + 10000, samu[,3]*100 + 10000)

# hélismur
a.heli <- as.raster(readPNG("data/chopper5(7).png"))
x <- samu[,2]*100
y <- samu[,3]*100
cx <- 15000
dx <- 8000
dy <- 12000
rasterImage(a.heli, x - dx, y - dy, x - dx + cx, y + cx - dy )

# légende
x <- 1037503 + 20000
y <- 6810919 - 10000

rasterImage(a.samu, x, y, x + 10000, y + 10000)
text(x + 10000, y + 5000, "SAMU", pos=4)

x <- x
y <- y - 10000
rasterImage(a.smur, x, y, x + 10000, y + 10000)
text(x + 10000, y + 5000, "SMUR", pos=4)

library(graphics) # cercle
x <- x + 5000
y <- y - 5000
symbols(x, y, circles = 1500, bg = "red", add = TRUE, inches = FALSE)
text(x + 8000, y , "SU", pos=4)

x <- x - 5000
y <- y - 12000
rasterImage(a.heli, x, y, x + 10000, y + 10000)
text(x + 10000, y + 5000, "HELISMUR", pos=4)
```

<img src="logos_files/figure-html/samu_smur_su-1.png" title="" alt="" style="display: block; margin: auto;" />





