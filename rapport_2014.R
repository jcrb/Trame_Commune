# complétude brute. Des corrections sont nécessaires pour DESTINATION
completude <- apply(dx, 2, function(x){round(100 * mean(!is.na(x)),2)})
# correction pour Destination et Orientation
# Les items DESTINATION et ORIENTATION ne s'appliquent qu'aux patients hspitalisés. On appelle hospitalisation les RPU pour lequels la rubrique MODE_SORTIE = MUTATION ou TRANSFERT. Pour les sorties à domicile, ces rubriques nepeuvent pas être complétées ce qui entraine une sous estimation importante du taux de complétude pour ces deux rubriques. On ne retient donc que le sous ensemble des patients hospitalisés pour lesquels les rubriques DESTINATION et ORIENTATION doivent ^tre renseignées.
hosp <- dx[dx$MODE_SORTIE %in% c("Mutation","Transfert"), c("DESTINATION", "ORIENTATION")]
completude.hosp <- apply(hosp, 2, function(x){round(100 * mean(!is.na(x)),2)})
completude['ORIENTATION'] <- completude.hosp['ORIENTATION']
completude['DESTINATION'] <- completude.hosp['DESTINATION']
# on retire les colonnes sans intérêt: id, EXTRACT
completude <- completude[-c(1,7)]
sort(completude)

# taux de complétude global. 
# Pour chacune des rubriques RPU calcule le taux de réponse (complétude)
#`dx dataframe
#`@return 

completude <- function(dx){
    # complétude brute. Des corrections sont nécessaires pour DESTINATION
    completude <- apply(dx, 2, function(x){round(100 * mean(!is.na(x)),2)})
    # correction pour Destination et Orientation
    # Les items DESTINATION et ORIENTATION ne s'appliquent qu'aux patients hspitalisés. On appelle hospitalisation les RPU pour lequels la rubrique MODE_SORTIE = MUTATION ou TRANSFERT. Pour les sorties à domicile, ces rubriques nepeuvent pas être complétées ce qui entraine une sous estimation importante du taux de complétude pour ces deux rubriques. On ne retient donc que le sous ensemble des patients hospitalisés pour lesquels les rubriques DESTINATION et ORIENTATION doivent ^tre renseignées.
    hosp <- dx[dx$MODE_SORTIE %in% c("Mutation","Transfert"), c("DESTINATION", "ORIENTATION")]
    completude.hosp <- apply(hosp, 2, function(x){round(100 * mean(!is.na(x)),2)})
    completude['ORIENTATION'] <- completude.hosp['ORIENTATION']
    completude['DESTINATION'] <- completude.hosp['DESTINATION']
    # on retire les colonnes sans intérêt: id, EXTRACT
    completude <- completude[-c(1,7)]
    return(sort(completude))
}

# diagramme en étoile de la complétude
#`@ data completude taux de completude global calculé par la fonction completude
#`@ usage radar.completude(completude(dx))

radar.completude <- function(completude){
    # diagramme en étoile
    radial.plot(completude, rp.type="p", 
    radial.lim=c(0,100), 
    start = 1.57, 
    clockwise = TRUE, 
    line.col = "red", 
    labels = names(completude), 
    cex.axis = 0.6,
    label.prop = 1.3, cex = .8
    )
}

# Durée de passage
# Différence entre la date-heure d'entrée et de sortie
