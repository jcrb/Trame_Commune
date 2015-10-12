
```{r samu_smur_su, fig.height=12, fig.align='center'}

# Carte des SU d'Alsace

# library(sp)
# library(png)

par(mar = c(0,0,2,0))

# carte de l'Alsace avec les villes sièges de SU
load("../../../Stat Resural/RPU_Doc/RPU_Carto-Pop-Alsace/Cartographie/Cartofile/als_ts.Rda") #ctss
plot(ctss, main = "Structures d'urgences en Alsace")
load("../../../Stat Resural/RPU_Doc/RPU_Carto-Pop-Alsace/Cartographie/Cartofile/tsvilles.Rda")
points(tsvilles[,2]*100,tsvilles[,3]*100,pch=20,col="red", cex = 1.2)
text(tsvilles[,2]*100,tsvilles[,3]*100,tsvilles[,1],cex=0.8,pos=4)
box()

# SMUR
smur <- tsvilles[tsvilles$NOM %in% c('WISSEMBOURG','HAGUENAU','SAVERNE','STRASBOURG','SELESTAT','COLMAR','MULHOUSE'),]
a.smur <- as.raster(readPNG("../Logos/data/ambulance15(14).png"))
cx <- 6000 # coefficient d'aggrandissement (n = 9000)
x <- smur[,2]*100
y <- smur[,3]*100
dpy <- 600 # déplacement de y (une valeur positive déplace vers le haut)
dpx <- 0 # déplacement horizontal
rasterImage(a.smur, x, y + dpy, x + cx, y + dpy + cx) # img, x1, y1, x2, y2

# SAMU
samu <- tsvilles[tsvilles$NOM %in% c('STRASBOURG', 'MULHOUSE'),]
a.samu <- as.raster(readPNG("../Logos/data/customer(3).png"))
rasterImage(a.samu, samu[,2]*100 - 10000, samu[,3]*100, samu[,2]*100 - 10000 + 10000, samu[,3]*100 + 10000)

# hélismur
a.heli <- as.raster(readPNG("../Logos/data/chopper5(7).png"))
x <- samu[,2]*100
y <- samu[,3]*100
cx <- 15000
dpx <- 8000
dpy <- 12000
rasterImage(a.heli, x - dpx, y - dpy, x - dpx + cx, y + cx - dpy )

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