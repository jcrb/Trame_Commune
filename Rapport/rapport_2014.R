
# routines

# format.n()
# completude()
# radar.completude()
    
    
#===============================================
# Formate un nombre à imprimer
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
# Taux complétude RPU
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
    
    # réorganise les données dans l'ordre de la FEDORU
    completude <- reorder.vector.fedoru(completude)
    #' completude <- completude[-c(1,7)]
    if (tri == TRUE)
        completude <- sort(completude) # tableau trié
    return(completude) 
}

#===============================================
# diagramme en étoile de la complétude
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

radar.completude <- function(completude, finess = NULL){
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

# Durée de passage
# Différence entre la date-heure d'entrée et de sortie

#===============================================
# Ordonner les colonnes du dataframe
#===============================================
reorder.dataframe.fedoru <- function(dx){
    dx <- dx[, c("FINESS","id","EXTRACT","CODE_POSTAL","COMMUNE","NAISSANCE",
                 "SEXE","ENTREE","MODE_ENTREE","PROVENANCE","TRANSPORT","TRANSPORT_PEC",
                 "SORTIE","MODE_SORTIE","DESTINATION","ORIENTATION","MOTIF",
                 "GRAVITE","DP")]
    return(dx)
}

#===============================================
# Ordonner les variable d'un vecteur
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
# count.CIM10
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
