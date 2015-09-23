####################################
#                                  #
#     routines rapport_2014.R      #
#                                  #
####################################

# format.n()
# completude()
# radar.completude()
# synthese.completude()
# reorder.dataframe.fedoru()
# reorder.vector.fedoru()
# teste.radar()
# count.CIM10()
# passage()
# horaire()
# datetime()
# pds()
# tab.completude
# passages2
# duree.passage
# summary.passages
# summary.sexe
# summary.entree
# summary.transport
# summary.ccmu
# summary.dateheure
# summary.mode.sortie
# summary.dp
# summary.age
# summary.wday
# summary.cp
# analyse.type.etablissement
# summary.destination
# summary.orientation
    
#===============================================
#
# Formate un nombre à imprimer
#
#===============================================
#'@author JcB - 2015-03-12
#'@description formate un nombre en ajoutant un espace pour les milliers
#'                                           une virgule décimale
#'                                           pas de notation scientifique
#'                                           deux chiffres significatifs
#'@usage format.n(7890.14) -> "7 890,14"
format.n <- function(x){
    return(format(x, big.mark = " ", decimal.mark = ",", scientific = FALSE, digits = 2))
}

# # complétude brute. Des corrections sont nécessaires pour DESTINATION
# completude <- apply(dx, 2, function(x){round(100 * mean(!is.na(x)),2)})
# # correction pour Destination et Orientation
# # Les items DESTINATION et ORIENTATION ne s'appliquent qu'aux patients hspitalisés. On appelle hospitalisation les RPU pour lequels la rubrique MODE_SORTIE = MUTATION ou TRANSFERT. Pour les sorties à domicile, ces rubriques nepeuvent pas être complétées ce qui entraine une sous estimation importante du taux de complétude pour ces deux rubriques. On ne retient donc que le sous ensemble des patients hospitalisés pour lesquels les rubriques DESTINATION et ORIENTATION doivent ^tre renseignées.
# hosp <- dx[dx$MODE_SORTIE %in% c("Mutation","Transfert"), c("DESTINATION", "ORIENTATION")]
# completude.hosp <- apply(hosp, 2, function(x){round(100 * mean(!is.na(x)),2)})
# completude['ORIENTATION'] <- completude.hosp['ORIENTATION']
# completude['DESTINATION'] <- completude.hosp['DESTINATION']
# # on retire les colonnes sans intérêt: id, EXTRACT
# completude <- completude[-c(1,7)]
# sort(completude)

#===============================================
#
# Taux complétude RPU
#
#===============================================

#'@title taux de complétude global. 
#'@description Pour chacune des rubriques RPU calcule le taux de réponse (complétude)
#'@details todo
#'@author JcB 2013-02-01, email{jeanclaude.bartier@gmail.com}
#'@license: creative commons
#'@keywords complétude
#'@family RPU
#'@param dx Un dataframe
#'@param calcul 2 options "percent" (défaut) ou "somme". Somme = nb de réponses
#'        non nulles. Percent = % de réponses non nulles.
#'@param tri si tri = TRUE (defaut) les colonnes sont triées par ordre croissant.
#'@return vecteur des taux de complétude
#'@example todo
#'@export

completude <- function(dx, calcul = "percent", tri = FALSE){
    # calcul du % ou de la somme
    percent <- function(x){round(100 * mean(!is.na(x)),2)}
    somme <- function(x){sum(!is.na(x))}
    "%!in%" <- function(x, y) x[!x %in% y]
    
    if(calcul == "percent")
        fun <- percent
    else
        fun <- somme
    
    #' complétude brute. Des corrections sont nécessaires pour DESTINATION
    completude <- apply(dx, 2, fun)
    
    #' correction pour Destination et Orientation
    #' Les items DESTINATION et ORIENTATION ne s'appliquent qu'aux patients hspitalisés. 
    #' On appelle hospitalisation les RPU pour lequels la rubrique MODE_SORTIE = MUTATION ou TRANSFERT. 
    #' Pour les sorties à domicile, ces rubriques ne peuvent pas être complétées ce qui entraine 
    #' une sous estimation importante du taux de complétude pour ces deux rubriques. 
    #' On ne retient donc que le sous ensemble des patients hospitalisés pour lesquels les rubriques 
    #' DESTINATION et ORIENTATION doivent être renseignées.
    hosp <- dx[dx$MODE_SORTIE %in% c("Mutation","Transfert"), c("DESTINATION", "ORIENTATION")]
    completude.hosp <- apply(hosp, 2, fun)
    completude['ORIENTATION'] <- completude.hosp['ORIENTATION']
    completude['DESTINATION'] <- completude.hosp['DESTINATION']
    
    #' Correction pour DP. Cette rubrique ne peut pas être remplie dans le cas où ORIENTATION =
    #' FUGUE, PSA, SCAM, REO
    # exemple d'utilisation de NOT IN
    dp <- dx[!(dx$ORIENTATION %in% c("FUGUE","PSA","SCAM","REO")), "DP"]
    # completude['DP'] <- mean(!is.na(dx$DP)) * 100 # erreur remplacer !is.na(dx$DP) par !is.na(dp$DP)
    completude['DP'] <- fun(dp)

    # réorganise les données dans l'ordre de la FEDORU
    completude <- reorder.vector.fedoru(completude)
    #' completude <- completude[-c(1,7)]
    if (tri == TRUE)
        completude <- sort(completude) # tableau trié
    return(completude) 
}

#===============================================
#
# diagramme en étoile de la complétude
#
#===============================================

#'@description dessine un graphe en étoile à partir des données retournées par "completude"
#'@author JcB 2013-02-01
#'@license: creative commons
#'@keywords spider, diagramme étoile
#'@family RPU
#'@param completude taux de completude global calculé par la fonction completude
#'@param finess character: nom de l'établissement. NULL (defaut) => tout le datafame
#'@return diagramme en étoile
#'@exemple radar.completude(completude(dx))
#'#'@exemple radar.completude(completude(dwis), "Wissembourg")
#'@export

radar.completude <- function(completude, finess = NULL, titre = NULL){
    library("openintro")
    library("plotrix")
    par(cex.axis = 0.8, cex.lab = 0.8) #' taille des caractères
    #' diagramme en étoile: réglage de la distance de la légende 
    #' par rapport à l'extrémité du trait. Toutes des distances sont fixées à 1.24 puis
    #' certaines sont augmentées ou diminuée en fonction de leur taille.
    prop <- rep(1.24, length(completude))
    prop[1] <- 1.1
    prop[2] <- 1.1
    prop[10] <- 1.27
    prop[19] <- 1.1
    
    if(is.null(finess))
      main = "Radar de complétude régional (%)"
    else
      main = paste0(finess, " - Radar de complétude (%)")
    
    radial.plot(completude, rp.type="p", 
        radial.lim=c(0,100), 
        radial.labels=c("0","20%","40%","60%","80%",""),
        poly.col = fadeColor("khaki",fade = "A0"),  #' line.col="khaki",
        start = 1.57, 
        clockwise = TRUE, 
        line.col = "red",
        #line.col = c(rep("yellow",3), rep("green", 4), rep("red", 9),rep("blue", 3))
        labels = names(completude), 
        cex.axis = 0.6,
        label.prop = prop, # positionne individuellement chaque label
        mar = c(3,0,3,0),
        show.grid.labels = 1, #' N = 4
        main = main,
        #boxed.labels = FALSE,
        boxed.radial = FALSE
    )
    # par()
}

#===============================================
#
# Synthèse Taux complétude RPU
#
#===============================================
#
#' A partir du dataframe initial (dx) calcule le tableau des taux de complétude
#' de l'ensemble des Finess présents dans dx. Le tableau comporte en ordonnée le
#' nom des établissements, en abcisse les différents items du RPU et à l'intersection
#' ligne/colonne la complétude correspondante. dx peut comprter un ou plusieurs Finess
#' et concerner une période variable (semaine, mois, année...)
#' Nécessite la librairie plyr pour la fonction ddply()
#'
#'@name synthese.completude
#'@param dx dataframe de type RPU
#'@return un dataframe
#'@usage synthese.completude(dx)
#'
synthese.completude <- function(dx){
    b <- ddply(dx, .(FINESS), completude)
    rownames(b) <- levels(factor(dx$FINESS))
    return(b)
}

#' autre usage: analyse individuelle
#' synthese.completude(dx[dx$FINESS == "Hag",])


# Durée de passage
# Différence entre la date-heure d'entrée et de sortie

#===============================================
#
# completude.time
#
#===============================================
# Pour un établissement donné, calcule le aux de complétude par mois, semaine, jours
# Au départ on dispose d'un dataframe de type RPU. Ce dataframe est splité en sous groupes sur une base temporelle (mois,
# jour, semaine...). Sur chacun des sous-groupes on applique la fonction "completude". Retourne un dataframe
# où chaque ligne correspond à une période et chaque colonne à un élément du RPU.
# Utilise "ddply" qui fonctionne comme tapply mais s'applique à un DF au lieu d'un vecteur et retourne un DF.
# TODO: exension à plusieurs établissements simultannéent; limitation à certaines colonnes.

#' @param dx un dataframe de type RPU
#' @param finess établissement concerné ('Wis', 'Hag', 'Sav', ...)
#' @param time factor de découpage
#' @param t un dataframe
#' @usage load("~/Documents/Resural/Stat Resural/RPU_2014/rpu2015d0112_provisoire.Rda")
#'        # old
#'        sav <- d15[d15$FINESS == "Sav",] # Saverne 2015
#'        t3 <- ddply(sav, .(month(as.Date(sav$ENTREE))), completude) # completude par mois
#'        # new
#'        library(xts)
#'        t3 <- completude.time(d15, "Sav", "day")
#'        a <- seq(as.Date("2015-01-01"), length.out = nrow(t3), by = 1)
#'        x <- xts(t3, order.by = a)
#'        plot(x[, "DP"], main = "CH Saverne - DIAGNOSTIC PRINCIPAL", ylab = "% de complétude")
#'        # TODO: tableau de complétude par mois et par Finess:
#'        t3 <- ddply(dx, .(dx$FINESS, month(as.Date(dx$ENTREE))), completude)
#'        # Application: rpu2014/Analyse/Completude/Analyse_completude

completude.time <- function(dx, finess,  time = "month"){
    library(lubridate)
    library(plyr)
    
    df <- dx[dx$FINESS == finess,] # Saverne 2015
    
    if(time == "month") t <- ddply(df, .(month(as.Date(df$ENTREE))), completude) # completude par période
    if(time == "day")   t <- ddply(df, .(yday(as.Date(df$ENTREE))), completude)
    if(time == "wday")  t <- ddply(df, .(wday(as.Date(df$ENTREE))), completude)
    if(time == "year")  t <- ddply(df, .(year(as.Date(df$ENTREE))), completude)
    if(time == "week")  t <- ddply(df, .(week(as.Date(df$ENTREE))), completude)
    
    return(t)
}

#===============================================
#
# Ordonner les colonnes du dataframe
#
#===============================================
# Réordonne les colonnes du dataframe RPU dans l'ordre défini par la FEDORU.
# Permet une meilleure cohérence du diagramme en étoile
reorder.dataframe.fedoru <- function(dx){
    dx <- dx[, c("FINESS","id","EXTRACT","CODE_POSTAL","COMMUNE","NAISSANCE",
                 "SEXE","ENTREE","MODE_ENTREE","PROVENANCE","TRANSPORT","TRANSPORT_PEC",
                 "SORTIE","MODE_SORTIE","DESTINATION","ORIENTATION","MOTIF",
                 "GRAVITE","DP")]
    return(dx)
}

#===============================================
#
# Ordonner les variable d'un vecteur
#
#===============================================
#' On part d'un vecteur contenant les intitulés du RPU et on le réordonne pour que
#' les intitulés doient mis dans l'ordre du rapport FEDORU (proposition de GillesFaugeras)
#' 
reorder.vector.fedoru <- function(dx){
    dx <- dx[c("FINESS","id","EXTRACT","CODE_POSTAL","COMMUNE","NAISSANCE",
                 "SEXE","ENTREE","MODE_ENTREE","PROVENANCE","TRANSPORT","TRANSPORT_PEC",
                 "SORTIE","MODE_SORTIE","DESTINATION","ORIENTATION","MOTIF",
                 "GRAVITE","DP")]
    # Changer l'intitulé des colonnes
    names(dx) <- c("FINESS","ID","EXTRACT","CODE POSTAL","COMMUNE","NAISSANCE",
    "SEXE","DATE D'ENTREE","MODE D'ENTREE","PROVENANCE","TRANSPORT","TRANSPORT PEC",
    "DATE DE SORTIE","MODE DE SORTIE","DESTINATION","ORIENTATION","MOTIF DE RECOURS",
    "CCMU","DP")
    return(dx)
}

#===============================================
#
# teste.radar
#
#===============================================
# data pour créer automatiquement un radar RPU et faire des test
teste.radar <- function(){
  n <- c("FINESS","id","EXTRACT","CODE_POSTAL","COMMUNE","NAISSANCE", "SEXE","ENTREE","MODE_ENTREE","PROVENANCE","TRANSPORT",
         "TRANSPORT_PEC","SORTIE","MODE_SORTIE","DESTINATION","ORIENTATION","MOTIF","GRAVITE","DP")
  a <- rep(80, length(n))
  names(a) <- n
  a <- reorder.vector.fedoru(a)
  radar.completude(a, finess = "Test - 1er trimestre 2015")
  legend(-150, -120, legend = c("complétude régionale"), lty = 1, lwd = 3, col = "blue", bty = "n", cex = 0.8)
  legend(90, -120, legend = c("complétude locale"), lty = 1, lwd = 3, col = "red", bty = "n", cex = 0.8)

}

#===============================================
#
# count.CIM10
#
#===============================================
#' 
#' examine un vecteur de caractères et compte le nombre de mots compatibles avec un code CIM10
#' NA n'est pas compté comme un code CIM10
#' @author JcB
#' @param vx un vecteur de character
#' @return n nombre de codes CIM1
#' @example count.CIM10(dx[dx$FINESS == "Col", "MOTIF"])
#'
count.CIM10 <- function(vx){
    Encoding(vx) <- "latin1" # suprime les caractères bloquants pour grep. Il s'agit de Colmar avec des caractères window du type \x9
    n <- grep("^[A-Z][0-9][0-9]", vx, value = TRUE) # n contient les codes compatibles CIM10
    return(length(n))
}              

#===============================================
#
# passage
#
#===============================================
#'
#'@title Horaires de passages
#'@name passage
#'@param he vecteur time de type hms
#'@param horaire = 'nuit', 'nuit profonde', 'jour'
#'@note necessite lubridate. Prend en compte toutes les heures et pas seulement celles
#'      comprises entre 0 et 72h (voir passage2)
#'@return un vecteur avec 2 éléments: le nombre de passages et le pourcentage en
#'        fonction de la période (jour, nuit)
#'@seealso horaire
#'@usage e <- datetime(dx$ENTREE); he <- horaire(e); nuit <- passage(he, "nuit")
#'
passage <- function(he, horaire = "nuit"){
    if(horaire == "nuit")
        nuit <- he[he > hms("19:59:59") | he < hms("08:00:00")]
    else if(horaire == "nuit profonde")
        nuit <- he[he < hms("08:00:00")]
    else if(horaire == "jour")
        nuit <- he[he > hms("07:59:59") & he < hms("20:00:00")]
    
    n.passages <- length(nuit) # passages 20:00 - 7:59
    p.passages <- n.passages / length(he)
    return(c(n.passages, p.passages))
}

#===============================================
#
# horaire
#
#===============================================
#'
#'@title extrait l'heure d'une date AAAA-MM-DD HH:MM:SS
#'@name horaire
#'@param date une date ou un vecteur au format DATE
#'@return un vecteur d'heures au format HH:MM:SS
#'@usage e <- datetime(dx$ENTREE); he <- horaire(e)
#'
horaire <- function(date){
    library(lubridate)
    return(hms(substr(date, 12, 20)))
}

# solution avec POSIXt
horaire2 <- function(date){
    return(paste(as.POSIXlt(date)$hour, as.POSIXlt(date)$min, as.POSIXlt(date)$sec, sep=":"))
}

# solution avec strsplit
# usage: d <- horaire3(d14$ENTREE)
horaire3 <- function(date){
    return(hms(strsplit(date, " ")[[1]][2]))
    # return(ymd(strsplit(date, " ")[[1]][1])) retourne la date
}

#===============================================
#
# datetime
#
#===============================================
#'
#'@title met une string date au format YYYY-MM-DD HH:MM:SS
#'@name datetime
#'@param date une chaine de caractère de type Date
#'@return un vecteur date time (lubridate)
#'@note nécessite lubridate
#'@usage Transforme des rubriques ENTREE et SORTIE en objet datetime
#'@usage e <- datetime(dx$ENTREE)
#'@seealso horaire, passage.nuit
#'
datetime <- function(date){
    return(ymd_hms(date))
}

#===============================================
#
# pdsa
#
#===============================================
#' Détermine si on est en horaire de PDS de WE (PDSWE) ou de semaine (PDSS) 
#' ou hors horaire de PDS (NPDS)
#' à partir d'une date.
#' @title
#' @name
#' @param dx vecteur date/heure au format YYYY-MM-DD HH:MM:SS
#' @return un vecteur de factor NPDS, PDSS, PDSW
#' @usage x <- "2009-09-02 12:23:33"; weekdays(as.Date(x)); pds(x) # NPDS
#' @usage pds(c("2015-05-23 02:23:33", "2015-05-24 02:23:33", "2015-05-25 02:23:33", 
#'              "2015-05-26 02:23:33", "2015-05-25 12:23:33", "2015-05-25 22:23:33"))
#'        # [1] "NPDS"  "PDSWE" "PDSWE" "PDSS"  "NPDS"  "PDSS" 
#' @usage Test Wissembourg sur une semaine:
#'        wis <- d14[d14$FINESS == "Wis" & 
#'                                  as.Date(d14$ENTREE) >= "2014-12-03" & 
#'                                  as.Date(d14$ENTREE) <= "2014-12-09", 
#'                                  c("ENTREE","FINESS")]
#'        wis$jour <- weekdays(as.Date(wis$ENTREE))
#'        wis$heure <- horaire(wis$ENTREE)
#'        wis$pdsa <- pds(wis$ENTREE)
#'        table(wis$pds)
#'        
#'        NPDS  PDSS PDSWE 
#'         136    35    52 

pdsa <- function(dx){
    # j <- as.Date(dx)
    j <- tolower(weekdays(as.Date(dx)))
    h <- horaire(dx)
    
    # un vecteur vide
    temp <- rep("NPDS", length(dx))
    
    # jour non renseigés
    temp[is.na(j)] = NA
    
    # Horaires de PDS le WE
    temp[j =="dimanche" | 
             j =="samedi" & h > hms("11:59:59") & h <= hms("23:59:59") |
             j =="lundi" & h < hms("08:00:00")] = "PDSWE"
    
    # horaires de PDS en semaine
    temp[j %in% c("mardi","mercredi","jeudi","vendredi") &
             (h > hms("19:59:59") | h < hms("08:00:00"))]= "PDSS"
    temp[j == "lundi" & h > hms("19:59:59")]= "PDSS"
    temp[j == "samedi" & h < hms("08:00:00")]= "PDSS"
    
    return(temp)
}

# REM sur xps les jours commencent par une minuscule alors que sur le Mac c'est une majuscule ?

#===============================================
#
# tab.completude
#
#===============================================
# faire un tableau de complétude par jour pendant une période donnée
# Permetde suivre les taux de complétude pour une structure et par période
#'@param dx dataframe de type RPU
#'@param d1 date de début
#'@param d2 date de fin
#'@param finess =  NULL ou un des finess abrégés autorisés. Si NULL, dx doit être spécifique
#'                 d'un établissement.
#'@usage hus <- d15[d15$FINESS == hus,]
#'       d1 <- as.Date("2015-01-01")
#'       d2 <- as.Date("2015-01-31")
#'       t <- tab.completude(hus, d1, d2)
#'       plot(t[,"DATE DE SORTIE"], type = "l", main = "Mode de sortie", ylab = "Taux de completude")
#'       t.zoo <- zoo(t) # nécessite la librairie zoo
#'       plot(xts(t.zoo$DP, order.by = as.Date(rownames(t.zoo))), las = 2, 
#'              main = "Diagnostic principal", ylab = "Taux de completude", cex.axis = 0.8)
#'      boxplot(t, las = 2, cex.axis = 0.8, ylab = "% de completude", main = "Complétude RPU")



tab.completude <- function(dx, d1, d2, finess = NULL){
    periode <- seq(as.Date (d1), as.Date(d2), 1)
    n <- length(periode)
    if(!is.null(finess)){
        dx <- dx[dx$FINESS == finess,]
    }
    tab <- completude(dx[as.Date(dx$ENTREE) == d1,])
    for(i in 2:n){
        j <- dx[as.Date(dx$ENTREE) == periode[i],]
        k <- completude(j)
        tab <- rbind(tab, k)
    }
    #tab <- data.frame(tab)
    rownames(tab) <- as.character(periode)
    return(tab)
}


#===============================================
#
# passages2 (nombre de passages)
#
#===============================================
#'
#' Détermine le nombre de RPU sur une plage horaire donnée
#' @author jcb
#' @description nécessite lubridate library(lubridate)
#' @param vx vecteur de type datetime (dx$ENTREE, dx$SORTIE par exemple). Transformé par ymd_hms
#'           Transform dates stored as character or numeric vectors to POSIXct objects
#' @param h1 char heure de début ou période: 'nuit', nuit_profonde', 'jour', 'pds', 
#'                                            'soir', '08:00:00'
#' @param h2 char heure de fin. h2 doit être > h1
#' @usage n.passages.nuit <- passages2(pop18$ENTREE, "nuit")
#' @return integer
#' 
passages2 <- function(vx, h1, h2 = NULL){
    e <- ymd_hms(vx) # vecteur des entrées
    he <- hms(substr(e, 12, 20)) # on ne conserve que la partie horaire
    n.passages <- length(he) # nb de passages
    
    if(h1 == "nuit"){
        # nombre de passages dont l’admission s’est effectuée sur la période [20h00 - 7h59] 
        n <- he[he > hms("19:59:59") | he < hms("08:00:00")] # passages 20:00 - 7:59
    }
    else if(h1 == "nuit_profonde"){
        #nombre de passages dont l’admission s’est effectuée sur la période [00h00 - 7h59]
        n  <- he[he < hms("08:00:00")]
    }
    else if(h1 == "jour"){
        #nombre de passages dont l’admission s’est effectuée sur la période [08h00 - 19h59]
        n <- he[he > hms("07:59:59") & he < hms("20:00:00")] # passages 7:59 - 20:00
    }
    else if(h1 == "soir"){
        #nombre de passages dont l’admission s’est effectuée sur la période [20h00 - 0:00]
        n <- he[he > hms("19:59:59") & he <= hms("23:59:59")] # passages 7:59 - 20:00
    }
    else if(!is.null(h2)){
        # nombre de passages dont l’admission s’est effectuée sur la période [h1 - h2] 
        n <- he[he > hms(h1) & he < hms(h2)]
    }
    
    n <- length(n)
    p <- n/n.passages
    
    return(c(n, p))
}

#===============================================
#
# duree.passage2
#
#===============================================
#'
#' @param dx dataframe RPU
#' @param h1 durée minimale en minutes (par défaut > 0)
#' @param h2 durée maximale en minutes (par défaut 4320 = 72 heures)
#' @param hors_uhcd si TRUE (défaut) on retire les engegistrements où ORIENTATION = UHCD
#' @return dataframe à 4 colonnes: entree, sortie, mode_sortie, duree (en mn),
#'                                 he (heure d'entrée), hs (heure de sortie)
#' 
duree.passage2 <- function(dx, h1 = 0, h2 = 4320, hors_uhcd = TRUE){
    # On forme un dataframe avec les heures d'entrées et de sortie auxquelle on rajoute 
    #pour certains calculs: MODE_SORTIE et ORIENTATION (Uhcd)
    # dataframe entrées-sorties, mode de sortie, orientation
    passages <- dx[, c("ENTREE", "SORTIE", "MODE_SORTIE", "ORIENTATION")] 
    # on ne conserve que les couples ENTREE-SORTIE complets
    passages <- passages[complete.cases(passages[, c("ENTREE", "SORTIE")]),] 
    n.passages <- nrow(passages)
    e <- ymd_hms(passages$ENTREE) # vecteur des entrées
    s <- ymd_hms(passages$SORTIE)
    # ON AJOUTE UNE COLONNE DUREE
    passages$duree <- as.numeric(difftime(s, e, units = "mins")) # vecteur des durées de passage en minutes
    # horaires seuls. Il faut isoler les heures de la date
    passages$he <- hms(substr(e, 12, 20)) # heures d'entrée
    passages$hs <- hms(substr(s, 12, 20)) # heures de sortie
    # on ne garde que les passages dont la durées > 0 et < ou = 72 heures
    passages <- passages[passages$duree > 0 & passages$duree < 3 * 24 * 60 + 1,]
    # passages hors UHCD
    if(hors_uhcd == TRUE){
        # un peu compliqliqué mais il faut éliminer les NA dans Orientation sinon
        # les résultats sont faux
        passages$ORIENTATION <- as.character(passages$ORIENTATION)
        passages$ORIENTATION[is.na(passages$ORIENTATION)] <- "na"
        passages <- passages[as.character(passages$ORIENTATION) != "UHCD",]
        # on remet tout en état
        passages$ORIENTATION[passages$ORIENTATION == "na"] <- NA
    }
    
    return(passages)
}

#===============================================
#
# summary.duree.passage
#
#===============================================
#'
#' Résumé de dp. dp est produit par duree.passages2 et se présente sous forme d'un 
#' data.frame à 4 colonnes
#' @name summary.duree.passage
#' @description analyse de la colonne durée 
#' @param dp un objet de type duree.passage2
#' @return - nb de durées
#'         - min durée
#'         - max durée
#'         - durée moyenne
#'         - durée médiane
#'         - écart-type
#'         - 1er quartile
#'         - 3ème quartile
#'         
summary.duree.passage <- function(dp){
    n <- nrow(dp) # nb de valeurs
    s <- summary(dp$duree) # summary de la colonne durée
    sd <- sd(dp$duree)
    
    a <- c(n, s["Min."], s["Max."], s["Mean"], s["Median"], sd, s["1st Qu."], s["3rd Qu."])
    
    names(a) <- c("n", "min", "max", "mean", "median", "sd", "q1", "q3")
    return(a)
}

#===============================================
#
# summary.passages
#
#===============================================
#'
#' @description analyse un objet de type duree.passage2
#' @param dp un objet de type duree.passage2. Correspond à un dataframe d'éléments du RPU dont
#'        la rurée de passage est conforme cad non nulle et inférieure à 72 heures
#'        
#' @return n.conforme               NB de durées conformes (>0 mn et < 72 heures)
#'         duree.moyenne.passage    durée moyenne d'un passage en minutes
#'         duree.mediane.passage    durée médiane d'un passage en minutes
#'         duree.moyenne.passage.dom    durée moyenne d'un passage en minutes si retour dom
#'         duree.mediane.passage.dom    durée médiane d'un passage en minutes
#'         duree.moyenne.passage.hosp    durée moyenne d'un passage en minutes si hospit.
#'         duree.mediane.passage.hosp    durée médiane d'un passage en minutes
#'         n.passage4               nombre de passages de moins de 4 heures
#'         n.hosp.passage4          nombre de passages de moins de 4 heures suivi d'hospitalisation
#'         n.domicile               nombre de retours à domicile
#'         n.dom.passage4           nombre de passages de moins de 4 heures suivi d'un retour à domicile
#'         n.dom                    nombre de retours à domicile
summary.passages <- function(dp){
    # dp <- duree.passage2(dx)
    
    tmax <- 4 * 60 + 1 # < 4 heures
    
    n.conforme <- nrow(dp)
    duree.moyenne.passage <- mean(dp$duree, na.rm = TRUE)
    duree.mediane.passage <- median(dp$duree, na.rm = TRUE)
    # durée de passage moyenne si retour à domicile
    duree.moyenne.passage.dom <- mean(dp$duree[dp$MODE_SORTIE == "Domicile"], na.rm = TRUE)
    duree.mediane.passage.dom <- median(dp$duree[dp$MODE_SORTIE == "Domicile"], na.rm = TRUE)
    # durée de passage moyenne si hospitalisation
    duree.moyenne.passage.hosp <- mean(dp$duree[dp$MODE_SORTIE %in% c("Mutation","Transfert")], na.rm = TRUE)
    duree.mediane.passage.hosp <- median(dp$duree[dp$MODE_SORTIE %in% c("Mutation","Transfert")], na.rm = TRUE)
    
    s.mode.sortie <- summary(as.factor(dp$MODE_SORTIE))
    
    n.passage4 <- length(dp$duree[dp$duree < tmax]) #nb passages < 4h
    
    # Nombre de RPU avec une heure de sortie conforme (]0-72h[ lors d'un retour au domicile:
    n.dom <- s.mode.sortie["Domicile"]
    # Nombre de RPU avec une heure de sortie conforme (]0-72h[ lors d'une hospitalisation
    # post-urgences:
    n.hosp <- s.mode.sortie["Mutation"] + s.mode.sortie["Transfert"] 
    
    n.transfert <- s.mode.sortie["Transfert"]   # nb de transfert
    n.mutation <- s.mode.sortie["Mutation"]     # Nombre de mutation interne
    n.deces <- s.mode.sortie["Décès"]           # nombre de décès
    
    n.hosp.passage4 <- length(dp$duree[dp$duree < tmax & 
          dp$MODE_SORTIE %in% c("Mutation","Transfert")]) #nb passages < 4h et hospitalisation
    
    n.dom.passage4 <- length(dp$duree[dp$duree < tmax & 
                      dp$MODE_SORTIE == "Domicile"]) #nb passages < 4h et retourà domicile
    
    a <- c(n.conforme, duree.moyenne.passage, duree.mediane.passage, duree.moyenne.passage.dom,
           duree.mediane.passage.dom, duree.moyenne.passage.hosp, duree.mediane.passage.hosp,
           n.passage4, n.hosp.passage4,
           n.dom.passage4, n.dom, n.hosp, n.transfert, n.mutation, n.deces)

    names(a) <- c("n.conforme", "duree.moyenne.passage", "duree.mediane.passage",
                  "duree.moyenne.passage.dom", "duree.mediane.passage.dom",
                  "duree.moyenne.passage.hosp", "duree.mediane.passage.hosp",
                  "n.passage4",
                  "n.hosp.passage4", "n.dom.passage4",  "n.dom", "n.hosp", "n.transfert", 
                  "n.mutation", "n.deces")
    
    return(a)
}


#===============================================
#
# summary.sexe
#
#===============================================
#'
#' @description analyse un vecteur formé d'une suite de H, F, ou I
#' @param vx vecteur de Char (sexe)
#' @return vecteur nommé
#' 
summary.sexe <- function(vx){
    sexe <- table(as.factor(vx))
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    
    p.femme <- sexe['F']*100/(sexe['F'] + sexe['M']) # % de femmes
    p.homme <- sexe['M']*100/(sexe['F'] + sexe['M']) # % d'hommes
    sex.ratio <- sexe['M'] / sexe['F'] # sex ratio
    n.hommes <- sexe['M']
    n.femmes <- sexe['F']
    tx.masculinite <- n.hommes / (n.hommes + n.femmes)
    
    a <- c(n, n.na, n.rens, p.rens, n.hommes, n.femmes, p.homme, p.femme, sex.ratio, tx.masculinite)
    names(a) <- c("N", "n.na", "n.rens", "p.rens", "n.hommes", "n.femmes", "p.hommes", "p.femmes",
                  "sex.ratio", "tx.masculinité")
    return(a)
}

#===============================================
#
# summary.entree
#
#===============================================
#'
#' @description analyse du vecteur ENTREE ou SORTIE
#' @param vx vecteur de Date ou de DateTime
#' @usage summary.entree(as.Date(pop75$ENTREE))
#' @TODO min et max ne s'affiche pas sous formr de date. Que donne hms
#' 
summary.entree <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    
    a <- c(n, n.na, n.rens, p.rens, min(as.Date(vx)), max(as.Date(vx)), max(vx) - min(vx))
    names(a) <- c("n", "n.na", "n.rens", "p.rens", "min", "max", "range")
    
    return(a)
}

#===============================================
#
# summary.transport
#
#===============================================
#' @description analyse du vecteur TRANSPORT
#' @p vx vecteur de Factor
#' @usage summary.transport(pop75$TRANSPORT)

summary.transport <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    s <- summary(as.factor(vx))
    
    n.perso <- s['PERSO']
    n.smur <- s['SMUR']
    n.vsav <- s['VSAB']
    n.ambu <- s['AMBU']
    n.fo <- s['FO']
    n.heli <- s['HELI']
    
    p.perso <- n.perso / n.rens
    p.smur <- n.smur / n.rens
    p.vsav <- n.vsav / n.rens
    p.ambu <- n.ambu / n.rens
    p.fo <- n.fo / n.rens
    p.heli <- n.heli / n.rens
    
    a <- c(n, n.na, p.na, n.rens, p.rens, n.fo, n.heli, n.perso, n.smur, n.vsav, n.ambu,
           p.fo, p.heli, p.perso, p.smur, p.vsav, p.ambu)
    
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens", "n.fo", "n.heli", "n.perso", "n.smur",
                  "n.vsav", "n.ambu", "p.fo", "p.heli", "p.perso", "p.smur", "p.vsav", "p.ambu")
    
    return(a)
}

#===============================================
#
# summary.ccmu
#
#===============================================
#' @description résumé du vecteur vx des CCMU
#' @param vx vecteur de factor CCMU
#' @usage summary.ccmu(dx$GRAVITE)
#' @return
#' 
summary.ccmu <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    s <- summary(factor(vx))
    
    n.ccmu1 <- s['1']
    n.ccmu2 <- s['2']
    n.ccmu3 <- s['3']
    n.ccmu4 <- s['4']
    n.ccmu5 <- s['5']
    n.ccmup <- s['P']
    n.ccmud <- s['D']
    
    p.ccmu1 <- n.ccmu1/n.rens
    p.ccmu2 <- n.ccmu2/n.rens
    p.ccmu3 <- n.ccmu3/n.rens
    p.ccmu4 <- n.ccmu4/n.rens
    p.ccmu5 <- n.ccmu5/n.rens
    p.ccmup <- n.ccmup/n.rens
    p.ccmud <- n.ccmud/n.rens
    
    a <- c(n, n.na, p.na, n.rens, p.rens, n.ccmu1, n.ccmu2, n.ccmu3, n.ccmu4, n.ccmu5, 
           n.ccmup, n.ccmud, p.ccmu1, p.ccmu2, p.ccmu3, p.ccmu4, p.ccmu5, p.ccmup,p.ccmud)
    
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens", "n.ccmu1", "n.ccmu2", "n.ccmu3", 
                  "n.ccmu4", "n.ccmu5", "n.ccmup", "n.ccmud", "p.ccmu1", "p.ccmu2", "p.ccmu3", 
                  "p.ccmu4", "p.ccmu5", "p.ccmup", "p.ccmud")
    
    return(a)
}

#===============================================
#
# summary.dateheure
#
#===============================================
#' @description résumé du vecteur vx des ENTREE ou SORTIE
#' @param vx vecteur ENTREE ou SORTIE
#' @usage summary.ccmu(dx$SORTIE)
#' @return
#' 
summary.dateheure <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    s <- summary(factor(vx))
    
    a <- c(n, n.na, p.na, n.rens, p.rens)
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens")
    
    return(a)
}

#===============================================
#
# summary.mode.sortie
#
#===============================================
#' @description résumé du vecteur vx des MODE_SORTIE
#' @param vx vecteur char MODE_SORTIE
#' @usage summary.mode.sortie(dx$MODE_SORTIE)
#' @return
#' 
summary.mode.sortie <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    s <- summary(as.factor(vx))
    
    n.dom <- s["Domicile"]
    n.hosp <- s["Mutation"] + s["Transfert"] 
    n.transfert <- s["Transfert"]   # nb de transfert
    n.mutation <- s["Mutation"]     # Nombre de mutation interne
    n.deces <- s["Décès"]           # nombre de décès
    
    p.dom <- n.dom / n.rens
    p.hosp <- n.hosp / n.rens
    p.transfert <- n.transfert / n.rens
    p.mutation <- n.mutation / n.rens
    p.deces <- n.deces / n.rens
    
    a <- c(n, n.na, p.na, n.rens, p.rens, n.dom, n.hosp, n.transfert, n.mutation, n.deces,
           p.dom, p.hosp, p.transfert, p.mutation, p.deces)
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens", 
                  "n.dom", "n.hosp", "n.transfert", "n.mutation", "n.deces",
                  "p.dom", "p.hosp", "p.transfert", "p.mutation", "p.deces")
    
    return(a)
}

#===============================================
#
# summary.dp
#
#===============================================
#' @description résumé du vecteur vx des DP (diagnostic principal)
#' @param vx vecteur char DP
#' @usage summary.dp(dx$DP)
#' @return
#' 
summary.dp <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    
    a <- c(n, n.na, p.na, n.rens, p.rens)
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens")
    
    return(a)
}

#===============================================
#
# summary.age
#
#===============================================
#' @description résumé du vecteur vx des AGE
#' @param vx vecteur char AGE
#' @usage summary.dp(dx$AGE)
#' @return
#' 
summary.age <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    s.age <- summary(vx)
    # summary
    s <- summary(vx)
    sd <- sd(vx, na.rm = TRUE)
    # age sans les NA
    n.inf1an <- sum(vx < 1, na.rm = TRUE) #nb de moins d'un an
    p.inf1an <- mean(vx < 1, na.rm = TRUE)
    
    n.inf15an <- sum(vx < 15, na.rm = TRUE) #nb de moins de 15 ans
    p.inf15an <- mean(vx < 15, na.rm = TRUE)
    
    n.inf18an <- sum(vx < 18, na.rm = TRUE)
    p.inf18an <- mean(vx < 18, na.rm = TRUE)
    
    n.75ans <- sum(vx > 74, na.rm = TRUE)  #nb de 75 ans et plus
    p.75ans <- mean(vx > 74, na.rm = TRUE)
    
    n.85ans <- sum(vx > 84, na.rm = TRUE)  #nb de 85 ans et plus
    p.85ans <- mean(vx > 84, na.rm = TRUE)
    
    n.90ans <- sum(vx > 89, na.rm = TRUE)  #nb de 90 ans et plus
    p.90ans <- mean(vx > 89, na.rm = TRUE)
    
    a <- c(n, n.na, p.na, n.rens, p.rens, n.inf1an, n.inf15an, n.inf18an, n.75ans, n.85ans, n.90ans,
           p.inf1an, p.inf15an, p.inf18an, p.75ans, p.85ans, p.90ans,
           s['Mean'], sd, s['Median'], s['Min.'], s['Max.'], s['1st Qu.'], s['3rd Qu.'])
    
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens","n.inf1an", "n.inf15ans", "n.inf18ans",
                  "n.75ans", "n.85ans", "n.90ans",
                  "p.inf1an", "p.inf15ans", "p.inf18ans", "p.75ans", "p.85ans", "p.90ans",
                  "mean.age", "sd.age", "median.age", "min.age", "max.age", "q1", "q3")
    
    return(a)
}

#===============================================
#
# summary.age.sexe
#
#===============================================
#' @description résumé des vecteurs AGE et SEXE
#' @param dx dataframe RPU
#' @usage summary.age.sexe(dx)
#' @return moyenne, écart-type, médiane par sexe
#' 
summary.age.sexe <- function(dx){
    
    sd <- tapply(dx$AGE, dx$SEXE, sd, na.rm = TRUE)
    sd.age.h <- sd[['M']]
    sd.age.f <- sd[['F']]
    
    s <- tapply(dx$AGE, dx$SEXE, summary)
    
    mean.age.h <- s[["M"]]["Mean"] # age moyen des hommes
    mean.age.f <- s[["F"]]["Mean"] # age moyen des femmes
    
    median.age.h <- s[["M"]]["Median"] # age médian des hommes
    median.age.f <- s[["F"]]["Median"] # age médian des femmes
    
    a <- c(mean.age.h, sd.age.h, mean.age.f, sd.age.f, median.age.h, median.age.f)
    
    names(a) <- c("mean.age.h", "sd.age.h", "mean.age.f", "sd.age.f", "median.age.h", 
                  "median.age.f")
    
    return(a)
}

#===============================================
#
# pyramide.age
#
#===============================================
#' @description pyramide des ages
#' @param dx datafrae RPU ou DF à 2 colonnes: AGE et SEXE
#' @param cut intervalles. Par défaut tranche d'age de 5 ans, borne sup exclue: [0-5[ ans
#' @param col.h couleur pour les hommes
#' @param col.f couleur pour les femmes
#' @param gap largeur de la colonne age (N = 1, varie de 0 à ...)
#' @details pyramid nécessite epicalc, pyramid.plot nécessite plotrix

pyramide.age <- function(dx, cut = 5, gap = 1, cex = 0.8,col.h = "light green", col.f = "khaki1"){
    # découpage du vecteur AGE en classes
    max = max(dx$AGE, na.rm = TRUE) 
    min = min(dx$AGE, na.rm = TRUE)
    a <- cut(dx$AGE, seq(from = min, to = max, by = cut), include.lowest = TRUE, right = FALSE)
    # division en 2 classes
    h <- as.vector(100 * table(a[dx$SEXE == "M"])/n.rpu)
    f <- as.vector(100 * table(a[dx$SEXE == "F"])/n.rpu)
    # graphe
    p <- pyramid.plot(h,f,
                 labels = names(table(a)), 
                 top.labels = c("Hommes", "Age", "Femmes"), 
                 main = "Pyramide des ages", 
                 lxcol = col.h, rxcol = col.f,
                 labelcex = cex,
                 gap = gap
                )
    return(p)
}

#===============================================
#
# tarru
#
#===============================================
#' @description Taux de Recours régional aux Urgences
#' @param pop.region population régionale de référence
#' @param cp vecteur des codes postaux. Détermine le nb de RPU générés par des Alsaciens
#' @usage pop.region <- pop.als.tot.2014 <- 1868773
#'        tarru(dx$CODE_POSTAL, pop.als.tot.2014)

tarru <- function(cp, pop.region, rpu.region){
    rpu.region <- sum(sapply(cp, is.cpals))
    tarru <- rpu.region * 100 / pop.region
    return(tarru)
}

#===============================================
#
# summary.wday
#
#===============================================
#' @description à partir du vecteur vx des ENTREE, retourne le nombre de RPU
#'                  pour chaque jour de la semaine
#' @param vx vecteur datetime
#' @ return vecteur nommé commençant le lundi
#' @usage summary.wday(dx$ENTREE)
#' 
summary.wday <- function(vx){
    a <- tapply(as.Date(vx), wday(as.Date(vx), label = TRUE), length)
    names(a) <- c("Dim","Lun","Mar","Mer","Jeu","Ven","Sam")
    b <- a[2:7]
    a <- c(b, a[1])
    return(a)
}

#===============================================
#
# summary.cp
#
#===============================================
#' @description résumé du vecteur vx des CODE_POSTAL (cp)
#' @param vx vecteur char CODE_POSTAL
#' @details NECESSITE LA BIBLIOTHEQUE RPU_Doc/mes.constantes
#' @usage summary.cp(dx$CODE_POSTAL)
#' @return - nb de CP renseignés
#'          - nb de résidents alsaciens
#'          - nb d'étrangers
#' 
summary.cp <- function(vx){
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    
    n.residents <- sum(sapply(vx, is.cpals))
    n.etrangers <- n.rens - n.residents
    
    a <- c(n, n.na, p.na, n.rens, p.rens,n.residents, n.etrangers)
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens", "n.residents", "n.etrangers")
    
    return(a)
}

#===============================================
#
# analyse_type_etablissement
#
#===============================================
#' @description fournit une liste d'indicateur à partir des données d'un établissement
#'              ou d'un groupe d'établissements. Voir rapport 2014: Analyse par type d'étblissement
#' @param es dataframe RPU (es = établissement de santé)
#' @usage # es non SAMU, siège de SMUR
#'          es <- dx[dx$FINESS %in% c("Wis","Hag","Sav","Sel","Col"),]
#'          analyse_type_etablissement(es)
#' 
analyse_type_etablissement <- function(es){
    # nombre de passages déclarés
    n.passages <- nrow(es)
    
    s <- summary.age(es$AGE)# summary
    # Nombre de RPU avec un âge renseigné
    n.age.ren <- s["n.rens"]
    n.inf1an <- s["n.inf1an"]
    n.inf15ans <- s["n.inf15ans"]
    n.75ans <- s["n.75ans"]
    
    s <- summary.cp(es$CODE_POSTAL)
    # Nombre de RPU avec un code postal renseigné
    n.cp.rens <- s["n.rens"]
    # Nombre ne veant pas de la région
    n.etrangers <- s["n.etrangers"]
    
    # par jour de semaine
    s <- summary.wday(es$ENTREE)
    n.lun <- s[1]
    n.mar <- s[2]
    n.mer <- s[3]
    n.jeu <- s[4]
    n.ven <- s[5]
    n.sam <- s[6]
    n.dim <- s[7]
    
    # passages de nuit
    n.nuit <- passage(horaire(es$ENTREE), "nuit")[1]
    # p.nuit <- passage(horaire(es$ENTREE), "nuit")[2]
    
    # passage en PDS
    t <- table(pdsa(es$ENTREE))
    n.pds <- t["PDSS"] + t["PDSWE"]
    
    #Nombre de RPU avec une date et heure d'entrée renseignées
    s <- summary.dateheure(es$ENTREE)
    n.h.rens <- s["n.rens"]
    
    # nombre avec moyen de transport renseigné
    s <- summary.transport(es$TRANSPORT)
    n.trans.rens <- s["n.rens"]
    n.fo <- s["n.fo"]
    n.heli <- s["n.heli"]
    n.perso <- s["n.perso"]
    n.smur <- s["n.smur"]
    n.vsav <- s["n.vsav"]
    n.ambu <- s["n.ambu"]
    
    # nombre avec CCMU renseigné
    s <- summary.ccmu(es$GRAVITE)
    n.ccmu.rens <- s["n.rens"]
    n.ccmu1 <- s["n.ccmu1"]
    n.ccmu2 <- s["n.ccmu2"]
    n.ccmu3 <- s["n.ccmu3"]
    n.ccmu4 <- s["n.ccmu4"]
    n.ccmu5 <- s["n.ccmu5"]
    n.ccmuP <- s["n.ccmup"]
    n.ccmuD <- s["n.ccmud"]
    n.ccmu45 <- n.ccmu4 + n.ccmu5
    
    # nombre de sorties conformes
    s <- summary.passages(duree.passage2(es))
    n.sorties.conf <- s["n.conforme"]
    mean.passage <- s["duree.moyenne.passage"]
    median.passage <- s["duree.mediane.passage"]
    
    n.passage4 <- s["n.passage4"] # nb de passages de moins de 4 heures
    n.hosp.passage4 <- s["n.hosp.passage4"] # nb de passages de moins de 4 heures suivi hospit.
    n.dom.passage4 <- s["n.dom.passage4"] # nb de passages de moins de 4 heures suivi retour dom.
    n.dom  <- s["n.dom"] # nb total de retour à domicile
    n.hosp  <- s["n.hosp"]
    n.transfert  <- s["n.transfert"]
    n.deces <- s["n.deces"]
    
    # Nombre de RPU avec un mode de sortie renseigné
    s <- summary.mode.sortie(es$MODE_SORTIE)
    n.mode.sortie <- s["n.rens"]
    n.dom2 <- s["n.dom"]
    n.transfert2 <- s["n.transfert"]
    n.mutation2 <- s["n.mutation"]
    n.deces2 <- s["n.deces"]
    n.hosp2 <- s["n.hosp"]
    
    a <- c(n.passages, n.age.ren, n.inf1an, n.inf15ans, n.75ans, n.cp.rens, n.etrangers, n.lun,
           n.mar, n.mer, n.jeu, n.ven, n.sam, n.dim, n.nuit, n.pds, n.h.rens, n.trans.rens, n.fo,
           n.heli, n.perso, n.smur, n.vsav, n.ambu, n.ccmu.rens, n.ccmu1, n.ccmu2, n.ccmu3, n.ccmu4,
           n.ccmu5, n.ccmuP, n.ccmuD, n.ccmu45, n.sorties.conf, mean.passage, median.passage,
           n.passage4, n.hosp.passage4, n.dom.passage4, n.dom, n.hosp, n.transfert, n.deces, n.mode.sortie,
           n.mutation2)
    
    names(a) <- c("n.passages", "n.age.ren", "n.inf1an", "n.inf15ans", "n.75ans", "n.cp.rens",
                  "n.etrangers", "n.lun", "n.mar", "n.mer", "n.jeu", "n.ven", "n.sam", "n.dim", 
                  "n.nuit", "n.pds", "n.h.rens", "n.trans.rens", "n.fo",
                  "n.heli", "n.perso", "n.smur", "n.vsav", "n.ambu", "n.ccmu.rens", "n.ccmu1", 
                  "n.ccmu2", "n.ccmu3", "n.ccmu4",
                  "n.ccmu5", "n.ccmuP", "n.ccmuD", "n.ccmu45", "n.sorties.conf", "mean.passage", 
                  "median.passage", "n.passage4", "n.hosp.passage4", "n.dom.passage4", "n.dom", 
                  "n.hosp", "n.transfert", "n.deces", "n.mode.sortie",
                  "n.mutation2")
    
    return(a)
}

#===============================================
#
# summary.destination
#
#===============================================
#' @description résumé du vecteur vx des DESTINATION
#' @param dx dataframe RPU
#' @param correction = TRUE: on ne retient que les destinations 
#'                           correspondant à une hospitalisation
#'

summary.destination <- function(dx, correction = TRUE){
    if(correction == TRUE){
        vx <- dx$DESTINATION[dx$MODE_SORTIE %in% c("Mutation","Transfert")]
    }
    else{
        vx <- dx$DESTINATION
    }
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    
    a <- c(n, n.na, p.na, n.rens, p.rens)
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens")
    
    return(a)
}

#===============================================
#
# summary.orientation
#
#===============================================
#' @description résumé du vecteur vx des ORIENTATION
#' @param dx dataframe RPU
#' @param correction = TRUE: on ne retient que les orientation 
#'                           correspondant à une hospitalisation
#'

summary.orientation <- function(dx, correction = TRUE){
    if(correction == TRUE){
        vx <- dx$ORIENTATION[dx$MODE_SORTIE %in% c("Mutation","Transfert")]
    }
    else{
        vx <- dx$ORIENTATION
    }
    n <- length(vx) # nb de valeurs
    n.na <- sum(is.na(vx)) # nb de valeurs non renseignées
    p.na <- mean(is.na(vx)) # % de valeurs non renseignées
    n.rens <- sum(!is.na(vx)) # nb de valeurs renseignées
    p.rens <- mean(!is.na(vx)) # % de valeurs renseignées
    
    s <- table(vx)
    
    # hospitalisés
    n.chir <- s['CHIR']
    n.med <- s['MED']
    n.obst <- s['OBST']
    n.si <- s['SI']
    n.sc <- s['SC']
    n.rea <- s['REA']
    n.uhcd <- s['UHCD']
    n.ho <- s['HO']
    n.hdt <- s['HDT']
    # non hospitalisés
    n.reo <- s['REO']
    n.scam <- s['SCAM']
    n.psa <- s['PSA']
    
    p.chir <- n.chir / n.rens
    p.med <- n.med / n.rens
    p.obst <- n.obst / n.rens
    p.si <- n.si / n.rens
    p.sc <- n.sc / n.rens
    p.rea <- n.rea / n.rens
    p.uhcd <- n.uhcd / n.rens
    p.ho <- n.ho / n.rens
    p.hdt <- n.hdt / n.rens
    p.reo <- n.reo / n.rens
    p.scam <- n.scam / n.rens
    p.psa <- n.psa / n.rens
    
    a <- c(n, n.na, p.na, n.rens, p.rens,
           n.chir, n.med, n.obst, n.si, n.sc, n.rea, n.uhcd, n.ho, n.hdt, n.reo, n.scam, n.psa,
           p.chir, p.med, p.obst, p.si, p.sc, p.rea, p.uhcd, p.ho, p.hdt, p.reo, p.scam, p.psa)
    
    names(a) <- c("n", "n.na", "p.na", "n.rens", "p.rens",
                  "n.chir", "n.med", "n.obst", "n.si", "n.sc", "n.rea", "n.uhcd", "n.ho", "n.hdt", 
                  "n.reo", "n.scam", "n.psa",
                  "p.chir", "p.med", "p.obst", "p.si", "p.sc", "p.rea", "p.uhcd", "p.ho", "p.hdt", 
                  "p.reo", "p.scam", "p.psa")
    
    return(a)
}

#===============================================
#
# summary.cp
#
#===============================================
#' @description résumé du vecteur vx des CODE_POSTAL (cp)
#' 
#' TODO
#' 

#===============================================
#
# evolution
#
#===============================================
#' @description calcule l'évolution entre 2 chiffres
#' @param a chiffre de l'année courante
#' @param b chiffre de l'année précédente
#' @return pourcentage d'augmentation ou de diminution
#' @usage evolution(n.rpu, n.rpu.2013)

evolution <- function(a, b){
    return((a - b)/b)
}

#===============================================
#
# mn2h
#
#===============================================
#' @description transforme des minutes en heure/mn
#' @param x integer = nombre de minutes
#' @return char
#' @usage 
#' 

mn2h <- function(x){
    h <- floor(x/60)
    mn <- round((x/60 - h) * 60, 0)
    a <- paste0(h, "h", mn)
    return(a)

}

#===============================================
#
# summary.rpu
#
#===============================================
#'@author JcB - 2015-08-24
#'@source summary_rpu.R
#'@details v1.0 24/08/2015
#'@description calcule le nombre de RPU par SU, territoire de santé et
#'              département à partir d'un dataframe RPU. Deux colonnes sont
#'              indispensables: ENTREE et FINESS
#'@param dx un dataframe RPU ou un dataframe réduit à 2 colonnes: ENTREE et
#'          FINESS
#'@return un objet "list"
#'        n nombre total de RPU
#'        n.tx  total RPU du territoire x
#'        n.67  total pour le 67
#'        n.68  total pour 68
#'        n.xxx total pour le Finess xxx
#'        p.tx  % pour territoire x
#'@usage s <- summary.rpu(d15); s[1]; s$debut; s$n

summary.rpu <- function(dx){
    
    debut <- min(as.Date(dx$ENTREE))
    fin <- max(as.Date(dx$ENTREE))
    
    t <- tapply(as.Date(dx$ENTREE), dx$FINESS, length)
    n <- sum(t)
    n.t1 <- sum(t['Hag'], t['Sav'], t['Wis'])
    n.hus <- sum(t['Hus'], t['HTP'], t['NHC'])
    n.t2 <- sum(n.hus, t['Ane'], t['Odi'], t['Dts'])
    n.t3 <- sum(t['Sel'], t['Col'], t['Geb'])
    n.t4 <- sum(t['Alk'], t['Tan'], t['Mul'], t['3Fr'], t['Dia'], t['Ros'],
                na.rm = TRUE)
    n.67 <- n.t1 + n.t2 + t['Sel']
    n.68 <- n - n.67
    
    p.t1 <- n.t1 / n
    p.t2 <- n.t2 / n
    p.t3 <- n.t3 / n
    p.t4 <- n.t4 / n
    
    n.wis <- t['Wis']
    n.hag <- t['Hag']
    n.sav <- t['Sav']
    n.ane <- t['Ane']
    n.odi <- t['Odi']
    n.dts <- t['Dts']
    n.sel <- t['Sel']
    n.col <- t['Col']
    n.geb <- t['Geb']
    n.alk <- t['Alk']
    n.tan <- t['Tan']
    n.mul <- t['Mul']
    n.dia <- t['Dia']
    n.ros <- t['Ros']
    n.3fr <- t['3Fr']
    
    # a est un objet composite formé de dates et de chiffres => on ne peut pas
    # en faire un vecteur car tous les éléments d'un vecteur doivent appartenir
    # au même type.
    a <- list(debut, fin, n, n.t1, n.t2, n.t3, n.t4, n.67, n.68, n.wis, n.hag, n.sav, n.ane,
              n.hus, n.odi, n.sel, n.col, n.geb, n.alk, n.tan, n.mul, n.dia,
              n.ros, n.3fr,
              p.t1, p.t2, p.t3, p.t4)
    
    names(a) <- c("debut", "fin", "n", "n.t1", "n.t2", "n.t3", "n.t4", "n.67", "n.68",
                  "n.wis", "n.hag", "n.sav", "n.ane", "n.hus", "n.odi",
                  "n.sel", "n.col", "n.geb", "n.alk", "n.tan", "n.mul",
                  "n.dia", "n.ros", "n.3fr",
                  "p.t1", "p.t2", "p.t3", "p.t4")
    
    return(a)
}