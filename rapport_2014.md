# Rapport 2014 - version FEDORU
JcB  
28/01/2015  

Rapport 2014 respectant les préconisations de la FEDORU
=======================================================

La proposition ici se fait autour de 4 points (représentant chacun une partie de rapport) :



le ‘préambule’ 
==============
    
    En préalable à des résultats d’activité, cette partie peut donner un panorama de l’offre de soins en local, une description des dispositifs de remontées de données, une présentation d’actualités, mais doit surtout faire un point sur les données utilisées (suivi qualitatif et quantitatif).

a. Cartographie l’offre de soins (positionner les SU, SMUR) +/- organisation des soins (ex : PDSA)

b. Possibilité de rappeler quelques éléments de contexte démographique régional et les chiffres clés de la santé en région

c. Point sur le fonctionnement du concentrateur régional : organisation, flux de données (schéma type ?)

i. Exhaustivité des données urgences 

- Nombre de SU transmettant des données / Nombre total de SU

#### nombre de SU transmettants des RPU: 15
#### nombre de SU ne transmettant pas: 1
#### taux d'exhaustivité: 94 %

- Nombre total de RPU / Nb total de passages SRVA (Serveur de veille et d'alerte)

- Nombre total de RPU / Nb total de passages SAE (Statistique annuelle des établissements de santé) (suivant disponibilité)

ii. Qualité des données urgences

- Nombre de logiciel différents utilisés dans la région.

- Graphique en araignée du taux de complétude (% donnée manquante) (après correction données aberrantes) des variables RPU, au moins sexe, âge, durée séjour, ccmu, orientation, code diag principal, motif de recours.

![](rapport_2014_files/figure-html/completude-1.png) 

```
## Please visit openintro.org for free statistics materials
## 
## Attaching package: 'openintro'
## 
## The following object is masked from 'package:datasets':
## 
##     cars
```

```
## Warning in rep(point.symbols, length.out = nsets): 'x' is NULL so the
## result will be NULL
```

```
## Warning in rep(point.col, length.out = nsets): 'x' is NULL so the result
## will be NULL
```

![](rapport_2014_files/figure-html/completude-2.png) 


- Critères de cohérence :

- % CCMU 4 et 5 sortie externe.



#### 0.12

#### % de CCMU 4 et 5 renvoyé à domicile: 0.12 %

    - % Diagnostic hors thésaurus SFMU
    - % âge > 18 ans dans SU pédiatriques.
    - % diag féminin chez homme et inverse



d.      Les travaux de la FEDORU et les travaux nationaux

le tableau récapitulatif dénommé “Chiffres clefs”
=================================================
    
Parfois en début de rapport, parfois en fin, c’est une partie courte et synthétique présentant, sous forme de chiffres clefs, les grands déterminants de l'activité. Choix d’un titre commun. 

__CORE [C]__ obligatoire __SUPPLEMENTAL [S]__ facultatif




## Nombre de SU 
(nombre de SU pédiatriques, nombre de SU polyvalents, nombre SU adultes) [C]

- Nombre de SU: 16

### Nombre de SU publics / privés [C]

- nombre de SU dans le secteur public: NA
- nombre de SU dans le secteur privé: NA

## Nombre de passages dans l'année [C]

40 509

## Moyenne quotidienne de passages [C]

110.9836

## %(N) d'évolution par rapport à année N-1 [C]

## %(N) public/privé [C]

- nombre de RPU publics: 33936 (83.77 %)
- nombre de RPU privés: 6573 (16.23 %)

## SEXE

### %(N) Femme [C]

49.39 % (19 997)

### %(N) Homme [C]

50.61 % (20 488)

## AGE


### % (N) < 1 an [C]
1991 (4.92 %)

### %(N) < 18 ans [C]
12769 (31.52 %)

### %(N) >= 75 ans [C]
5671 (14 %)

### Age moyen

- age moyen[C]: 37.13 ans.

- age moyen des hommes [S] (pourquoi 'homme et femme' en SUPP ?) 35.34 ans.
- age moyen des femmes [S] 38.99 ans.

### Taux de recours (définition FEDORU) régional aux urgences. [S]
Utilisation des données INSEE qui collent le plus à la période d’étude (projections ou données consolidées)



### % sur activité les jours de  WE [S]
= ((Nbsam+NbDim/2)-(sommeNbJourSEm/5))/ ((Nbsam+NbDim/2)*100 [Limousin]

6.35 % d'activité supplémentaire le WE.

NB: le calcul ne tient pas compte des jours fériés (à faire).

## % du delta entre mois le plus chargé et le mois le moins chargé [S]

100 %

Durées de passage
-----------------


- durée moyenne de passage 174.2 mn.
- écart-type: 173.5035961 mn.
- médiane: 123 mn.
- nombre de passages > 4 heures: 8465 (23.61 %).


```r
# horaires seuls. Il faut isoler les heures de la date
he <- hms(substr(e, 12, 20))
# passages de nuit
nuit <- he[he > hms("19:59:59") | he < hms("08:00:00")]
n.passages.nuit <- length(nuit) # passages 20:00 - 7:59
p.passages.nuit <- n.passages.nuit / n.passages

# passages en nuit profonde
nuit.profonde <- he[he < hms("08:00:00")]
n.passages.nuit.profonde <- length(nuit.profonde)
p.passages.nuit.profonde <- n.passages.nuit.profonde / n.passages
```

### % passages nuit (définition FEDORU) [C]
nombre de passages dont l’admission s’est effectuée sur la période [20h00 - 7h59] divisé par l’ensemble des passages

23.61 % (N = 8561)

### % passages nuit profonde (définition FEDORU) [C]
nombre de passages dont l’admission s’est effectuée sur la période [00h00 - 7h59] divisé par l’ensemble des passages

11.27 % (N = 4088)

Mode de transport
-----------------



###  %(N) d'arrivée perso [S]

68.91 % (N = 19 913)

###  %(N) d'arrivée SMUR [S]

1.06 % (N = 305)

###  %(N) d'arrivée VSAB [S]

10.3 % (N = 2 977)

###  %(N) d'arrivée Ambulance [S]

19.13 % (N = 5 527)

Gravité (CCMU)
--------------



###  %(N) CCMU 1 et 2 [C]
84.16% (n = 26549)

###  %(N) CCMU 4 et 5 [C]
1.38% (n = 434)

###  %(N) Médico-chir [C]

###  %(N) Traumato [C]

###  %(N) Psy [C]
0.39% (n = 124)

Durée de présence
-----------------

### Durée de séjour (hors UHCD): 
moyenne +/- ET ; médiane (IQR) [C]

- moyenne: 174.2 mn
- écart-type: 173.5035961 mn
- médiane: 123 mn
- IQR: 169 mn

###  % (N) passages ayant durée attente > 1 heure [S]
Pas calculable en Alsace :-(

###  %  (N) passages durée séjour > 4h [S]
23.61% (n = 8465)

Mode de sortie
--------------



###  %  (N)Externe [C]

75.36 % (N = 21 497)

###  %  (N)Hospitalisation [C]

23.1 % (N = 6 590)

###  %  (N)Transfert [C]

1.54 % (N = 439)

###  %  (N)Sortie non convenue [C]

4.58 % (N = 336)

###  %  (N)Décès [C]
0% (n = 1)


les résultats régionaux
========================

partie centrale du rapport dans laquelle tous les résultats d’activité sont présentés dans le déroulement d’une trame. Le principe est de passer en revue les variables du RPU (communes à tous normalement), d’en proposer une exploitation si elles présentent un intérêt, puis de proposer quelques croisements associés à chaque variable s’ils semblent pertinents (présence d’un bloc ‘croisement’ spécifique dans chaque partie ci dessous).

Volume global d’activité, cumul de passages
-------------------------------------------

#### historique du nombre de passages

#### [1][2] par année et de la moyenne quotidienne du nombre de passages

Graphe avec 2 axes des abcisses:

- total par année
- moyenne quotidienne par année

![](rapport_2014_files/figure-html/c1-1.png) 

- nombre de passages en 2014: 40 509 soit en moyenne 111 par jour.

#### [3] % d’augmentation annuelle sur les années disponibles


% de variation 2014/2013 = -88.23 % 

croisements :

#### [4][5] nombre de passages et % par type de structures (CH, CHU, privé), année N

On  utilise le fichier __Hopitaux_Alsace2.csv__ qui comporte les informations suivantes:

- nom de la structure
- aabréviation pour lesRPU
- FINESS géographique
- FINESS juridique
- Groupe juridique (ex. GHSV)
- Territoire de santé
- Zone de proximité
- type
- statut
- nombre total de lits
- nombre de lits de chirurgie
- nombre de lits de médecine

Le calcul se fait après un merging de dx et de hop.


```
     2014        %          
CH   "24 746.00" "    61.09"
CHU  " 9 190.00" "    22.69"
PSPH " 6 573.00" "    16.23"
     "40 509.00" "   100.01"
```
#### [6] % CH, CHU, privé sur les années disponibles

Caractéristique des patients : âge
-----------------------------------

- [7][8] moyenne âge +/- écart type année N

moyenne d'age: 37.129925 ans, ecart-type: 27.8`ans.

- [9] répartition par tranche âge

```
[1] "ToDo"
```

```
a
    [0,5)    [5,10)   [10,15)   [15,20)   [20,25)   [25,30)   [30,35) 
     5965      2460      2759      2617      2515      2490      2211 
  [35,40)   [40,45)   [45,50)   [50,55)   [55,60)   [60,65)   [65,70) 
     1929      2003      1924      1869      1736      1584      1440 
  [70,75)   [75,80)   [80,85)   [85,90)   [90,95)  [95,100) [100,105) 
     1335      1482      1763      1456       809       138        20 
[105,110) [110,115) [115,120] 
        0         3         0 
```

![](rapport_2014_files/figure-html/tranche-1.png) 

- [10] pyramide des âges des patients accueillis aux urgences année N


```r
h <- as.vector(100 * table(a[dx$SEXE == "M"])/n.rpu)
f <- as.vector(100 * table(a[dx$SEXE == "F"])/n.rpu)
pyramid.plot(h,f, labels = names(table(a)), top.labels = c("Hommes", "Age", "Femmes"), main = "Pyramide des ages", lxcol = "light green", rxcol = "khaki1")
```

![](rapport_2014_files/figure-html/pyramide-1.png) 

```
## [1] 5.1 4.1 4.1 2.1
```

- croisements : 

- [11] sexe-moyenne âge femme/homme, année N

```
##        F        I        M 
## 38.99030 16.41667 35.33831
```

- [12] proportion des âge extrêmes (moins de 1 an, plus de 90 ans) par mois, année N

![](rapport_2014_files/figure-html/age_extreme-1.png) ![](rapport_2014_files/figure-html/age_extreme-2.png) ![](rapport_2014_files/figure-html/age_extreme-3.png) ![](rapport_2014_files/figure-html/age_extreme-4.png) 


Caractéristique des patients : sexe
------------------------------------

- [13] répartition en fonction du sexe année N 

```r
sexe
```

```
## 
##     F     I     M 
## 19997    24 20488
```

- [14] sex ratio, année N

sex-ratio = 1.0245537

- croisements :

- [15] sex ratio H/F par classe d’âge, année N


```r
# ventilation par age et sexe sur 3 colonnes (H,f,I). L'AGE EST EXPRIMÉ EN TRANCHES D'AGE. Le rapport r est le sex ratio par tranches d'age.
age.s <- tapply(dx$AGE, list(dx$SEXE, a), length)
r <- age.s['M',]/age.s['F',]
r
```

```
##      [0,5)     [5,10)    [10,15)    [15,20)    [20,25)    [25,30) 
## 1.27588842 1.13194444 0.99927484 0.88544669 0.91539634 1.02276423 
##    [30,35)    [35,40)    [40,45)    [45,50)    [50,55)    [55,60) 
## 1.16568627 1.11868132 1.16774892 1.19134396 1.00000000 1.18090452 
##    [60,65)    [65,70)    [70,75)    [75,80)    [80,85)    [85,90) 
## 1.15217391 1.16216216 1.25126476 0.97600000 0.68546845 0.56620022 
##    [90,95)   [95,100)  [100,105)  [105,110)  [110,115)  [115,120] 
## 0.34162521 0.21052632 0.05263158         NA 2.00000000         NA
```

```r
plot(r, type = "l", ylab = "Sex ratio", xlab = "age")
abline(h = 1, lty = 2, col = "red")

x <- barplot(r, las = 2, plot = FALSE)
points(x,r, pch = 16, add = TRUE)
```

```
## Warning in plot.xy(xy.coords(x, y), type = type, ...): "add" n'est pas un
## paramètre graphique
```

![](rapport_2014_files/figure-html/ratio_classe_age-1.png) 

```r
# pb: comment conserver le nom des graduations x ?
```


- [16] taux de masculinité

0.51

Provenance géographique des patients
------------------------------------

- provenance région / hors région / étranger, année N
- cartographie des pourcentages d’activité que représentent les passages de patients provenant des départements limitrophes, année N
- cartographie du nombre de passages régional en fonction du lieu de résidence du patient (code postal) année N
- pourcentage de patient ne résidant pas dans une zone postale où est installée une structure d’urgence, année N

croisements :

- cartographie des taux de recours année N
- taux de recours / âge et / sexe, année N
- évolution par mois des moyennes quotidiennes de passages des populations région / hors région / étranger, année N

Arrivée aux urgences
--------------------

- Moyenne quotidienne du nombre de passages par mois (basée sur la date d’admission) année N

```r
# On procède en 2 temps:
# 1. on calcule le total des RPU par jour de l'année. On obtient un vecteur de 365 valeurs. Chaque valeur est repérée par la date du jour.
rpu.jour <- tapply(as.Date(dx$ENTREE), as.Date(dx$ENTREE), length)
# 2. on redécoupe ce vecteur en mois sur la base de la date du jour. Pour chaque mois on calcule la moyenne et l'écart-type.
mean.rpu.jour <- tapply(rpu.jour, month(as.Date(names(rpu.jour))), mean)
sd.rpu.jour <- tapply(rpu.jour, month(as.Date(names(rpu.jour))), sd)
plot(mean.rpu.jour, type = "b", ylim = c(900,1400), ylab = "nombre moyen de RPU", xlab = "Mois", main = "Moyenne quotidienne du nombre de passages par mois", xlim = c(1, 12))
```

![](rapport_2014_files/figure-html/mean_month-1.png) 

- Nombre de passages par semaine (basée sur la date d’admission) année N (positionner les vacances scolaires de la zone concernée)
![](rapport_2014_files/figure-html/rpu_semaine-1.png) 

- Moyenne quotidienne du nombre de passages par jour de semaine (basée sur la date d’admission), année N


- Répartition semaine/week-end (basée sur la date d’admission), année N
- Moyenne quotidienne du nombre de passages par « tranche d’heure » d’entrée , année N
- Pourcentage du nombre de passages par heure d’entrée et de sortie, année N
- Répartition jour/nuit (%), année N
- Nombre de passages et % réalisés durant les horaires PDS

croisements :

- Différentiel d’activité en % été/hiver (pourcentage de variation du nombre de passages entre l’été (ou l’hiver) et le reste de l’année) par - - type de SU (adulte, pédia, polyvalent)
- % de catégorie d’âge (pédia, âge moyen, géria) en fonction de la tranche d’heure d’entrée, année N
- % de classe d’âge (pédia, âge moyen, géria) en fonction de l’heure d’entrée, année N
- Taux d’hospitalisation et taux de retour à domicile en fonction de l’heure d’entrée, année N
- % du type de recours (trauma, psy, medico chir) en fonction de l’heure d’entrée, année N
- % du mode de transport à l’entrée (VSAV, SMUR, AP,…) en fonction de l’heure d’entrée, année N
- Moyenne quotidienne du nombre de passages par semaine, (basée sur la date d’admission) en fonction du type de SU (polyvalent, pédia, adulte), année N

Mode de transport à l’arrivée aux urgences
------------------------------------------

- Répartition des modes de transport (à l’arrivée aux urgences), année N, évolution

croisements :

- Mode de transport (à l’arrivée aux urgences) par département
- Mode de transport (à l’arrivée aux urgences) par type de structure (CH, CHU, privé)
- Mode de transport (à l’arrivée aux urgences) par tranche d'âge
- Mode de transport (à l’arrivée aux urgences) par CCMU regroupé ([1;2] ; 3 ; [4;5])

Gravité
-------
    
- répartition CCMU par regroupement ([1;2] ; 3 ; [4;5]; D; P), année N

croisements :
    
- pourcentage de CCMU 1 et 2 par tranche d'âge, année N
- pourcentage de CCMU 4 et 5 par tranche d'âge, année N

Motif de recours
----------------
    
    - Nombre de passages par motif, année N 

Pathologie
----------
    
- répartition par type d’urgences (med/chir, traumato, psy, toxico, autre), année N
- répartition par entêtes chapitre CIM 10, année N
- répartition par disciplines, année N
- répartition par diagnostic principal (top 10), année N
- répartition par diagnostic principal (top 5) en fonction du type d’urgences (med/chir, traumato, psy, toxico, autre), année N

croisements :
    
    - Type d’urgences (med/chir, traumato, psy, toxico, autre) en fonction de la classe d’âge (pédia, âge moyen, géria), année N
- TOP 10 diagnostic principal en fonction du sexe, année N 

Temps de passage
----------------
    
    - Temps de passage moyen +/- ET et médian (IQR), année N
- Répartition des passages par durée de passage en classe
- Pourcentage cumulé des temps de passage, année N

Croisements :
    
    - Temps de passage médian en fonction de la classe d’âge (pédia, âge moyen, géria), année N
- Temps de passage médian par type de structure (CH, CHU, privé), année N
- Temps de passage médian par type de SU (polyvalent / ped/ adulte), année N
- Temps de passage médian selon catégories de nombre de passage annuel dans les SU, année N
- Temps de passage médian en fonction du mode d'entrée année N
- Temps de passage médian en fonction de CCMU (CCMU1, CCMU4&5), année N
- Temps de passage médian en fonction du sexe, année N
- Temps de passage médian en fonction du type d’urgences (med/chir, traumato, psy, toxico, autre), année N
- TOP 10 diagnostic principal pour lequel le temps de passage médian est le plus long / le plus court, année N
- Temps de passage médian en fonction de l’orientation du patient, année N 
- Temps de passage médian en fonction de l’heure d’entrée et de l’heure de sortie, année N

Orientation
-----------

- Moyenne quotidienne du nombre de passages en fonction de l’orientation, année N 


```r
# on crée un objet orient (en éliminant les orientation nulles)
orient <- dx[!is.na(dx$ORIENTATION),]

# on crée un dataframe de 365 jours et 13 colonnes comptant le nb de RPU pour chaque orientation. Pourrait se transformer en xts pour tracer une ligne par orientation.
t <- tapply(as.Date(orient$ENTREE), list(as.Date(orient$ENTREE), factor(orient$ORIENTATION)), length)

# on calcule les 13 moyennes
m <- apply(t, 2, mean, na.rm = TRUE)
m
```

```
##      CHIR     FUGUE       HDT        HO       MED      OBST       PSA 
## 41.516129  1.250000  1.153846  1.000000 83.387097  1.363636  9.322581 
##       REA       REO        SC      SCAM        SI      UHCD 
##  5.516129  4.333333  7.387097  1.684211 12.290323 70.354839
```

```r
# pour contrôler les sommes:
apply(t, 2, sum, na.rm = TRUE)
```

```
##  CHIR FUGUE   HDT    HO   MED  OBST   PSA   REA   REO    SC  SCAM    SI 
##  1287    15    15     3  2585    15   289   171   130   229    32   381 
##  UHCD 
##  2181
```

```r
# graphiques
xts <- xts(t, order.by = as.Date(rownames(t)))
plot(rollmean(xts[,"UHCD"], 7), ylim = c(0,170), minor.ticks = FALSE, main = "Orientation", col = "green")
lines(rollmean(xts[, "CHIR"], 7), col = "red")
lines(rollmean(xts[, "MED"], 7), col = "blue")
legend("topleft", legend = c("UHCD", "MED", "CHIR"), col = c("green","blue","red"), lty = 1, bty = "n")
```

![](rapport_2014_files/figure-html/moyenne-orientation-1.png) 


croisements :

- Moyenne quotidienne du nombre d’hospitalisations en fonction de la classe d’âge (pédia, âge moyen, géria), année N
- Taux d’hospitalisation en fonction de jour/nuit et âge, année N
- Top 5 des disciplines pathologiques pour lesquelles le taux d’hospitalisation est le plus fort, année N
- Top 5 des disciplines pathologiques pour lesquelles le taux de retour à domicile est le plus fort, année N
- Cartographie du taux de retour à domicile en fonction du lieu de résidence du patient (code postal) année N
- Nombre de décès par semaine, année N

les analyses par filière
------------------------

focus sur une sous déclinaison de l’activité (pathologies traceuses ou traits caractéristiques de la patientèle)

#### AVC : (définition FEDORU)

- Nombre de passages AVC urgences, année N
- Nombre de passages AVC urgences, déclinaison par département, établissement, année N
- Moyenne quotidienne, année N
- Age moyen, année N
- Répartition par classe âge en pourcentage, année N
- Répartition par sexe en pourcentage, année N
- TOP 5 pourcentage par code CIM 10, année N
- Répartition we/semaine en pourcentage, année N
- Répartition par tranche heure en pourcentage, année N
- Répartition par orientation en pourcentage, année N
- Temps de passage médian, année N


Définitions FEDORU
====================

taux de recours (de la région ou département)
---------------------------------------------
nombre de passages dans les services d’urgences (de la région ou département) de patients résidant dans une zone donnée (code postal ou commune) divisé par la population estimée de cette zone sur la pérriode donnée.

pourcentage de passage nuit
---------------------------
nombre de passages dont l’admission s’est effectuée sur la période [20h00 - 7h59] divisé par l’ensemble des passages

pourcentage de passage nuit profonde
------------------------------------
nombre de passages dont l’admission s’est effectuée sur la période [00h00 - 7h59] divisé par l’ensemble des passages

tranche d’âge
-------------
```{}
<28j;[28j-1A[;[1-5[;[5-10[;[10-15[;[15-18[;[18-30[;[30-45[;[45;65[;[65-75[;[75;85[;>85ans
```

sexe
-----
M/F/I

« tranche d’heure » d’entrée
----------------------------
matinée [8h00-11h59] ; début d’après midi [12h00-15h59] ; fin d’après midi [16h00-19h59] ; soirée [20h00-23h59] ; nuit profonde [00h00;07h59]

horaire PDS
------------

- week end PDSA: du samedi 12h00 au lundi 07h59
- en semaine: du lundi au vendredi de [20h00 - 07h59] le lendemain
- jour férié: de 00h00 à 23h59
- pont PDSA: de 00h00 à 23h59

Les ponts PDSA sont ceux qui sont qualifiés comme tel par l’ARS et qui génère à ce titre le mise en place d’une régulation PDSA sur cette période. Si un pont PDSA, ou un jour férié survient un vendredi, le samedi matin suivant sera dès lors intégré à l’activité PDSA.

durée de passage en classe
--------------------------
2 types de regroupements :

- moins de 4 heures ; 4 heures et plus
- moins d’une heure ; entre 1 et 2 heures ; de 2 à 4 heures ; de 4 à 8 heures ; de 8 à 12 heures ; entre 12 et 72 heures ; (bornes supérieures exclues)

Temps de calcul
===============


```r
proc.time() - ptm
```

```
##    user  system elapsed 
<<<<<<< HEAD
##  13.898   0.564  15.109
=======
##   6.251   0.176   6.428
>>>>>>> 90f04a2e5f763a5a3a3ced670d76a0a038366092
```

