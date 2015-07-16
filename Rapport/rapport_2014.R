#####################
#                   #
#     routines      #
#                   #
#####################

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
#'@param tri si tri = TRUE (defaut) les colonnes sont triées par ordre croissant.
#'@return vecteur des taux de complétude
#'@example todo
#'@export

completude <- function(dx, tri = FALSE){
    #' complétude brute. Des corrections sont nécessaires pour DESTINATION
    completude <- apply(dx, 2, function(x){round(100 * mean(!is.na(x)),2)})
    
    #' correction pour Destination et Orientation
    #' Les items DESTINATION et ORIENTATION ne s'appliquent qu'aux patients hspitalisés. 
    #' On appelle hospitalisation les RPU pour lequels la rubrique MODE_SORTIE = MUTATION ou TRANSFERT. 
    #' Pour les sorties à domicile, ces rubriques ne peuvent pas être complétées ce qui entraine 
    #' une sous estimation importante du taux de complétude pour ces deux rubriques. 
    #' On ne retient donc que le sous ensemble des patients hospitalisés pour lesquels les rubriques 
    #' DESTINATION et ORIENTATION doivent être renseignées.
    hosp <- dx[dx$MODE_SORTIE %in% c("Mutation","Transfert"), c("DESTINATION", "ORIENTATION")]
    completude.hosp <- apply(hosp, 2, function(x){round(100 * mean(!is.na(x)),2)})
    completude['ORIENTATION'] <- completude.hosp['ORIENTATION']
    completude['DESTINATION'] <- completude.hosp['DESTINATION']
    
    #' Correction pour DP. Cette rubrique ne peut pas être remplie dans le cas où ORIENTATION =
    #' FUGUE, PSA, SCAM, REO
    "%!in%" <- function(x, y) x[!x %in% y]
    dp <- dx[dx$ORIENTATION %!in% c("FUGUE","PSA","SCAM","REO"),]
    completude['DP'] <- mean(!is.na(dx$DP)) * 100

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
#'@note necessite lubridate
#'@return un vecteur avec 2 éléments: le nombre de passages et le pourcentage en
#'        fonction de la période (jour, nuit)
#'@seealso horaire
#'@usage e <- datetime(dx$ENTREE); he <- horaire(e); nuit <- passsage.nuit(he, "nuit")
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
    return(hms(substr(date, 12, 20)))
}

# somution avec POSIXt
horaire2 <- function(date){
    return(paste(as.POSIXlt(date)$hour, as.POSIXlt(date)$min, as.POSIXlt(date)$sec, sep=":"))
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
# pds
#
#===============================================
#' Détermine si on est en horaire de PDS de WE (PDSWE) ou de semaine (PDSS)
#' à partir d'une date.
#' @title
#' @name
#' @param dx vecteur date/heure au format YYYY-MM-DD HH:MM:SS
#' @return
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
#'        wis$pds <- pds(wis$ENTREE)
#'        table(wis$pds)
#'        
#'        NPDS  PDSS PDSWE 
#'         136    35    52 

pds <- function(dx){
    j <- as.Date(dx)
    h <- horaire(dx)
    
    # un vecteur vide
    temp <- rep("NPDS", length(dx))
    
    # jour non renseigés
    temp[is.na(j)] = NA
    
    # Horaires de PDS le WE
    temp[weekdays(j)=="Dimanche" | 
             weekdays(j)=="Samedi" & h > hms("11:59:59") & h <= hms("23:59:59") |
             weekdays(j)=="Lundi" & h < hms("08:00:00")] = "PDSWE"
    
    # horaires de PDS le WE
    temp[weekdays(j) %in% c("Mardi","Mercredi","Jeudi","Vendredi") &
             (h > hms("19:59:59") | h < hms("08:00:00"))]= "PDSS"
    temp[weekdays(j) == "Lundi" & h > hms("19:59:59")]= "PDSS"
    
    return(temp)
}

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




