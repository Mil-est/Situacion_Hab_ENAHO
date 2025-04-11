clear
cls

*========================================================*
*                		 MÓDULO 100                      *
*========================================================*


* Adecual el intervalo de años !
forvalues a=2019/2023 {			

clear
cd "Ruta de recursos" //ruta
* Adecuar la ruta, en caso de ser necesario


unicode analyze enaho01-`a'-100.dta
unicode encoding set "latin1"
unicode translate enaho01-`a'-100.dta
use enaho01-`a'-100.dta


egen idviv = concat(conglome vivienda)
duplicates report idviv
duplicates drop idviv, force


* DEPARTAMENTOS

gen str2 DEPARTAMENTOS=substr(ubigeo, 1, 2)
destring DEPARTAMENTOS, replace

label define dptos 1 "Amazonas" 2 "Ancash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
label values DEPARTAMENTOS dptos
tab DEPARTAMENTOS


* REGIONES NATURALES

recode dominio (1 2 3 8=1 "Costa") (4 5 6=2 "sierra") (7=3 "selva"), gen (REGION_NATURAL) 
label var REGION_NATURAL "Región Natural"
tab REGION_NATURAL


* AREA

tab estrato 
gen AREA=1 if estrato<=5
replace AREA=2 if estrato==6 | estrato==7 | estrato==8
label def area 1 "Urbana" 2 "Rural"
label values AREA area
tab AREA [iw=factor07]


* AÑO

gen AÑO = `a'




//     VARIABLES DE INTERÉS      
//===============================


* TIPO DE VIVIENDA

rename p101 TIPO_VIVIENDA
tab TIPO_VIVIENDA [iw=factor07]



* HOGARES SEGÚN RÉGIMEN DE TENENCIA DE LA VIVIENDA

rename p105a REGIMEN_TENENCIA_VIV 
tab REGIMEN_TENENCIA_VIV [iw=factor07]


* HOGARES QUE POSEEN TÍTULO DE PROPIEDAD

rename p106a TITULO_DE_PROPIEDAD
tab TITULO_DE_PROPIEDAD [iw=factor07]


* registrado en SUNARP

rename p106b TITULO_REGISTRADO_SUNARP
tab TITULO_REGISTRADO_SUNARP [iw=factor07]


* VIVIENDAS SEGÚN NÚMERO DE HABITACIONES

gen N_HABITACIONES = p104 
recode N_HABITACIONES (5/15=5)

label var N_HABITACIONES fuentes_fin
label define fuentes_fin 1 "1 HAB" 2 "2 HAB" 3 "3 HAB" 4 "4 HAB" 5 "5 A MÁS"
label values N_HABITACIONES fuentes_fin

tab N_HABITACIONES [iw=factor07]


* VIVIENDAS CON LICENCIA DE CONSTRUCCIÓN

rename p104b1 LICENCIA_DE_CONSTRUCCION
tab LICENCIA_DE_CONSTRUCCION [iw=factor07]


* VIVIENDAS CONSTRUIDAS CON ASISTENCIA TÉCNICA

rename p104b2 ASISTENCIA_TECNICA
tab ASISTENCIA_TECNICA [iw=factor07]


* MATERIAL EN LAS PAREDES

rename p102 MATERIAL_PAREDES
tab MATERIAL_PAREDES [iw=factor07]


* MATERIAL EN LOS PISOS

rename p103 MATERIAL_PISOS
tab MATERIAL_PISOS [iw=factor07]


* MATERIAL EN LOS TECHOS

rename p103a MATERIAL_TECHOS
tab MATERIAL_TECHOS [iw=factor07]



* HOGARES CON ACCESO A ALUMBRADO ELÉCTRICO

la var p1121 "electricidad" 
label define electricidad 0 "No" 1 "Sí", modify
la values p1121 electricidad

rename p1121 ALUMBRADO_ELECTRICO
tab ALUMBRADO_ELECTRICO [iw=factor07]


* HOGARES CON ACCESO A SERVICIO DE AGUA

rename p110 PROCEDENCIA_SERVICIO_AGUA
tab PROCEDENCIA_SERVICIO_AGUA [iw=factor07]


* HOGARES CON ACCESO A ALCANTARILLADO

rename p111a ACCESO_ALCANTARILLADO
tab ACCESO_ALCANTARILLADO [iw=factor07]


* COMBUSTIBLE MÁS UTILIZADO PARA COCINAR EN EL HOGAR

rename p113a COMBUSTIBLE_PARA_COCINA
tab COMBUSTIBLE_PARA_COCINA [iw=factor07]


* NECESIDADES BÁSICAS INSATISFECHAS

tab nbi1
rename nbi1 NBI1_VIVIENDAS
tab nbi2
rename nbi2 NBI2_HACINAMIENTO



// LIMPIEZA DE LA BASE

duplicates tag idviv , gen (duplicado)
tab duplicado
drop duplicado


tab result
drop if result==3 | result==4 | result==5 | result==7


keep conglome vivienda idviv ubigeo dominio AREA REGION_NATURAL DEPARTAMENTOS AÑO factor07 TIPO_VIVIENDA N_HABITACIONES LICENCIA_DE_CONSTRUCCION ASISTENCIA_TECNICA MATERIAL_PAREDES  MATERIAL_PISOS MATERIAL_TECHOS REGIMEN_TENENCIA_VIV TITULO_DE_PROPIEDAD TITULO_REGISTRADO_SUNARP ALUMBRADO_ELECTRICO PROCEDENCIA_SERVICIO_AGUA ACCESO_ALCANTARILLADO COMBUSTIBLE_PARA_COCINA NBI1_VIVIENDAS NBI2_HACINAMIENTO


* Adecuar la ruta para los dta intermedios !
cd "ruta de dtas intermedios" //ruta

save `a'-viviendas.dta , replace
