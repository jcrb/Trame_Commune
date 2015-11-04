# routines pour la cartographie

# Liste
# - chalandise
# - attribJoin

#===============================================
#
# chalandise (code_postal)
#
#===============================================
#'
#' @description Etablit la liste des codes postaux (CP) pour un FINESS donné
#'              Pour chaque CP associe le nombre de RPU correspondants
#'              NOTE: ne conserve que les données de l'Alsace
#'              Permet de caractériser l'attractivité d'un établissement
#' @param dx dataframe de type RPU
#' @param dxId colonne de dx utilisée. Par défaut CODE_POSTAL. En pratique les items suceptibles
#'              d'être cartographiés sont le CODE_POSTAL, la COMMUNE, le FINESS (zone de 
#'              proximité), le territoire de santé, l'arrondissement et le canton.
#' @param finess le code de l'établissement
#' @usage cp.hus <- chalandise(d15, "Hus")
#'        summary(as.numeric(cp.hus))
#'        head(cp.hus)
#'        67200 67000 67100 67300 67800 67400 
#'        9645  8535  5622  2785  2121  1581
#' @return une liste nommée

chalandise <- function(dx, dxId = "CODE_POSTAL", finess){
    cp <- factor(dx[, dxId][dx$FINESS == finess])# cp <- factor(dx$CODE_POSTAL[dx$FINESS == finess])
    # on ne garde que les cp de la région
    b <- factor(cp[substr(as.character(cp),1,2) %in% c("67","68")])
    # summary retourne le nb de RPU par code postal
    s <- summary(b)
    # on forme un dataframe avec 2 colonnes
    a <- names(s)
    b <- as.numeric(as.character(s))
    c <- data.frame(a,b)
    names(c) <- c("CP", "RPU")
    
    return(c)
}


#------------------------------------------------------------------
#
#   attribJoin
#
#------------------------------------------------------------------
#'@source R et espace p.196
#'@author groupe ElementR
#'@description cette fonction réalise une jonction entre une table attributaire (daframe 
#'associé à un shapefile) et des données externes contenues dans un tableau. La procédure
#'utilise match qui ne modifie pas l'ordre des lignes de la table attributaire (contrairement 
#'à merge). L'ordre des lignes de la table attributaire doit impérativement correspondre à 
#'l'ordre de la composante cartographique.
#'@param df le tableau externe
#'@param spdf objet spatial 
#'@param df.field variable de jointure (tableau externe)
#'@param spdf.field variable de jointure (objet spatial)
#'@usage a <- attribJoin(df = cp.hus, spdf = cp67, df.field = "CP", spdf.field = "ID")
#'       b <- a@data
#'
attribJoin <- function(df, spdf, df.field, spdf.field){
    if(is.factor(spdf@data[, spdf.field]) == TRUE){
        spdf@data[, spdf.field] <- as.character(spdf@data[, spdf.field])
    }
    if(is.factor(df[, df.field]) == TRUE){
        df[, df.field] <- as.character(df[, df.field])
    }
    spdf@data <- data.frame(spdf@data, df[match(spdf@data[, spdf.field], df[, df.field]),])
    return(spdf)
}

#------------------------------------------------------------------
#
#   carte.recours
#
#------------------------------------------------------------------
#'@description dessine la carte des taux de recours par code postal pour 
#'              un établissement
#' @param sp spatalPolygonDataframe ex. cp67. NB le dataframe doit comporter une colonne TAUX
#' @param palette palette de couleur pour la discrétisation (compatible colorBrewer)
#' @param titre titre principal du graphique
#' @param q vecteur numérique de discrétisation (varie entre 0 et 1).
#'          par défaut 6 classes
#' @param names vecteur de character correspondant à q
#' @usage carte.recours(cp67, titre = "Test") #par codes postaux du 67 pour les HUS


carte.recours <- function(sp, palette = "Oranges", titre = "", q = NULL, names = NULL){
    library(RColorBrewer)
    
    # choix pour Alsace -> devrait le normaliser pour 10.000 habitants
    if(is.null(q))
        q <- c(0, 0.01, 0.05, 0.10, 0.15, 0.20, 1)
    else q = q
    if(is.null(names))
        names <- c("< 1 %", "1-5 %", "5-10 %", "10-15 %", "15-20 %", "> 20 %")
    else names = names
    
    # palette de length(q) - 1 couleurs
    greypal <- brewer.pal(n = length(q) - 1, name = palette)
    greypal[1] <- "#FFFFFF" # moins de 1% = blanc
    
    # nom.col.taux <- "TAUX"
    # taux <- paste("sp@data$", nom.col.taux, sep="") # à tester sp@data$TAUX
    sp@data$TAUX <- sp@data$RPU / sp@data$POP2010
    
    q2 <- as.character(cut(sp@data$TAUX, breaks = q, 
                           labels = greypal, 
                           include.lowest = TRUE, right = FALSE))
    
    plot(sp, col = q2, main = titre)
    
    # legendQ5 crée un affichage sous forme d'intervalles. Remplacé par names (cf.supra)
    # legendQ5 <- as.character(levels(cut(cp67@data$TAUX * 100, breaks = q * 100, include.lowest = TRUE, right = FALSE)))
    # legendQ5 <- paste(legendQ5, "%")
    
    legend("bottomright", legend = names, bty="n", fill=greypal, cex=0.8, 
           title="Taux de recours au SU")
    
    # échelle
    arrows(par()$usr[1]+1000, par()$usr[3]+1000, par()$usr[1]+10000, par()$usr[3]+1000, lwd = 2, code = 3, angle = 90, length = 0.05)
    text(par()$usr[1]+5050, par()$usr[3]+2700, "10 km", cex = 0.8)
    
}