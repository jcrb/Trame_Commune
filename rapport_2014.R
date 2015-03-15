

#===============================================
# Taux complétude RPU
#===============================================

#'@title taux de complétude global. 
#'@description Pour chacune des rubriques RPU calcule le taux de réponse (complétude)
#'@details todo
#'@author JcB 2013-02-01, email{jeanclaude.bartier@gmail.com}
#'@keywords complétude
#'@family RPU
#'@param dx Un dataframe
#'@return vecteur des taux de complétude
#'@example todo
#'@export


completude <- function(dx){
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
    
    #' completude <- completude[-c(1,7)]
    return(sort(completude)) # tableau trié
}

#===============================================
# diagramme en étoile de la complétude
#===============================================

#'@description dessine un graphe en étoile à partir des données retournées par "completude"
#'@author JcB 2013-02-01
#'@keywords spider, diagramme étoile
#'@family RPU
#'@param completude taux de completude global calculé par la fonction completude
#'@return diagramme en étoile
#'@exemple radar.completude(completude(dx))
#'@export

radar.completude <- function(completude){
    library("openintro")
    library("plotrix")
    par(cex.axis = 0.8, cex.lab = 0.8, oma=c(0,0,0,0)) #' taille des caractères
    #' diagramme en étoile
    radial.plot(completude, rp.type="p", 
    radial.lim=c(0,100), 
    radial.labels=c("0","20%","40%","60%","80%",""),
    poly.col = fadeColor("khaki",fade = "A0"),  #' line.col="khaki",
    start = 1.57, 
    clockwise = TRUE, 
    line.col = "red", 
    labels = names(completude), 
    cex.axis = 0.6,
    label.prop = 1.25, 
    show.grid.labels = 1, #' N = 4
   
    )
    par(cex.axis = 1, cex.lab = 1)
}

# Durée de passage
# Différence entre la date-heure d'entrée et de sortie
