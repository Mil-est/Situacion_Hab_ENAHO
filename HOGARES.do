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
use enaho01-`a'-100.dta, clear


egen idhogar = concat(conglome vivienda hogar)
egen idvivienda = concat(conglome vivienda)



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


* Registrado en SUNARP

rename p106b TITULO_REGISTRADO_SUNARP
tab TITULO_REGISTRADO_SUNARP [iw=factor07]


* VIVIENDAS CON LICENCIA DE CONSTRUCCIÓN

rename p104b1 LICENCIA_DE_CONSTRUCCION
tab LICENCIA_DE_CONSTRUCCION [iw=factor07]


* VIVIENDAS CONSTRUIDAS CON ASISTENCIA TÉCNICA

rename p104b2 ASISTENCIA_TECNICA
tab ASISTENCIA_TECNICA [iw=factor07]


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



* FINANCIAMIENTO PARA VIVIENDA
*==============================


* Obtención de crédito hipotecario

gen ACCESO_FIN = 0
replace ACCESO_FIN = 1 if p107b1==1 | p107b2==1 | p107b3==1 | p107b4==1
replace ACCESO_FIN = 0 if p107b1==. & p107b2==. & p107b3==. & p107b4==.
	
la var ACCESO_FIN "credito" 
label define credito 0 "No" 1 "Sí"
la values ACCESO_FIN credito

tab ACCESO_FIN [iw=factor07]

	
* DIFICULTADES EN EL CRONOGRAMA DE PAGO DEL CRÉDITO

rename p107e DIFICULTADES_PAGO_CREDITO
tab DIFICULTADES_PAGO_CREDITO [iw=factor07]


* MONTO DE CRÉDITO PROMEDIO segun destino del crédito

**Monto Total del Crédito recibido

*	sum p107d1 //destinado a: Comprar casa, departamento
*	sum p107d2 //destinado a:Comprar TERRENO PARA vivienda
*	sum p107d3 //destinado a:Mejoramiento y/o ampliación            
*	sum p107d4 //destinado a: Construcción de vivienda nueva

	* Visualizacion de los datos
	tabstat p107d1 p107d2 p107d3 p107d4, stat (mean)  	
	tabstat p107d1 p107d2 p107d3 p107d4  [aw=factor07], stat (mean)


	
* FUENTE DEL FINANCIAMIENTO

forvalues n=1/10 { // 9 FUENTES
	if `n'==5{
	continue
	}

	 forvalues r=1/4 {  // 4 DESTINOS
	 	gen D`r'F`n' =.
		replace D`r'F`n'=0 if p107c`r'`n'==0
		replace D`r'F`n'=1 if p107c`r'`n'==`n'
	}
	}
	


* NECESIDADES BÁSICAS INSATISFECHAS

tab nbi3
rename nbi3 NBI3_VIV_SINSSHH
tab nbi4
rename nbi4 NBI24_NIÑOS_NO_ESCUELA
tab nbi5
rename nbi5 ALTA_DEPEND_ECON



// LIMPIEZA DE LA BASE

duplicates tag idhogar , gen (duplicado)
tab duplicado
drop duplicado

tab result
drop if result==3 | result==4 | result==5 | result==7



keep conglome vivienda hogar idhogar idvivienda ubigeo dominio AREA REGION_NATURAL TIPO_VIVIENDA DEPARTAMENTOS AÑO factor07 REGIMEN_TENENCIA_VIV TITULO_DE_PROPIEDAD TITULO_REGISTRADO_SUNARP ALUMBRADO_ELECTRICO PROCEDENCIA_SERVICIO_AGUA ACCESO_ALCANTARILLADO COMBUSTIBLE_PARA_COCINA ACCESO_FIN DIFICULTADES_PAGO_CREDITO p107d1 p107d2 p107d3 p107d4 D1F1 D2F1 D3F1 D4F1 D1F2 D2F2 D3F2 D4F2 D1F3 D2F3 D3F3 D4F3 D1F4 D2F4 D3F4 D4F4 D1F6 D2F6 D3F6 D4F6 D1F7 D2F7 D3F7 D4F7 D1F8 D2F8 D3F8 D4F8 D1F9 D2F9 D3F9 D4F9 D1F10 D2F10 D3F10 D4F10 p107b1 p107b2 p107b3 p107b4 NBI3_VIV_SINSSHH NBI24_NIÑOS_NO_ESCUELA ALTA_DEPEND_ECON LICENCIA_DE_CONSTRUCCION ASISTENCIA_TECNICA
	
	
	
* Adecuar la ruta para los dta intermedios !

cd "ruta de bases intermedias" // ruta
save `a'-hogares.dta, replace
	
 }




clear
cls
*========================================================*
*                		 MÓDULO 500                      *
*========================================================*


* Adecual el intervalo de años !
forvalues a=2019/2023 { 

clear
cd "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\03. Recursos"

use enaho01a-`a'-500.dta

egen idhog = concat(conglome vivienda hogar)
duplicates report idhog

* AÑO

gen AÑO = `a'


* INFORMALIDAD

tab ocupinf
rename ocupinf INFORMALIDAD


// LIMPIEZA DE LA BASE

tab p203, nol
keep if p203==1

keep conglome vivienda hogar AÑO  INFORMALIDAD


* Adecuar la ruta para los dta intermedios !
cd "ruta de bases intermedias" // ruta
save `a'-m500.dta , replace

}



clear
cls

*========================================================*
*                		 MÓDULO 200                      *
*========================================================*


forvalues c=2019/2023 {

* Adecual el intervalo de años !
cd "Ruta de recursos" //ruta
clear
use enaho01-`c'-200.dta

egen idhog = concat(conglome vivienda hogar)
duplicates report idhog


// SEXO
//------------------
tab p207
rename p207 SEXO
tab SEXO 


// EDAD
//------------------
tab p208a
rename p208a EDAD
tab EDAD 


// ESTADO CIVIL
//------------------
tab p209
rename p209 ESTADO_CIVIL
tab ESTADO_CIVIL 


// P203 (RELACION CON EL JEFE DE HOGAR)
//-------------------------------------
tab p203
tab p203,nolabel

gen hijo_present = 0
bysort idhog (p203): replace hijo_present = 1 if p203 == 3
bysort idhog (hijo_present): replace hijo_present = hijo_present[_N]


gen pareja_present = 0
bysort idhog (p203): replace pareja_present = 1 if p203 == 2 
bysort idhog (pareja_present): replace pareja_present = pareja_present[_N]



************************************************************************
gen familiar_present = 0
bysort idhog (p203): replace familiar_present = 1 if p203 == 4 | p203 == 5|p203== 6 | p203==7 | p203==11
bysort idhog (familiar_present): replace familiar_present = familiar_present[_N]

gen no_familiar_present = 0
bysort idhog (p203): replace no_familiar_present = 1 if p203==10
bysort idhog (no_familiar_present): replace no_familiar_present = no_familiar_present[_N]

gen trabajador_hogar_present = 0
bysort idhog (p203): replace trabajador_hogar_present = 1 if p203 == 8
bysort idhog (trabajador_hogar_present): replace trabajador_hogar_present = trabajador_hogar_present[_N]


*************************************************************************


// AÑO
gen AÑO = `c'


// Limpiando base
tab p203, nol
keep if p203==1 //info jefe de hogar

keep conglome vivienda hogar AÑO  SEXO EDAD ESTADO_CIVIL hijo_present pareja_present familiar_present  no_familiar_present trabajador_hogar_present


cd "ruta de bases intermedias" // ruta

save `c'-m200.dta , replace
}



clear
cls
*========================================================*
*                		 SUMARIAS                      *
*========================================================*



* Adecual el intervalo de años !
forvalues b=2019/2023 {

* Adecual el intervalo de años !
cd "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\03. Recursos"
clear

use sumaria-`b'.dta


egen idhog = concat(conglome vivienda hogar)
duplicates report idhog



// INFORMALIDAD
//------------------
tab estrsocial 
rename estrsocial ESTRATO_SOCIAL
tab ESTRATO_SOCIAL 

tab  pobreza
rename pobreza POBREZA
tab POBREZA 


*ingreso mensual por hogar
gen ING_MENS = inghog2d/12

*gasto mensual por hogar
gen GAST_MENS = gashog2d/12

gen GAST_MENS_DEF = gashog2d/ (ld*12) //deflactado



// AÑO
gen AÑO = `b'

keep conglome vivienda hogar AÑO  ESTRATO_SOCIAL POBREZA ING_MENS GAST_MENS GAST_MENS_DEF
 

cd "ruta de bases intermedias" // ruta

save `b'-sum.dta , replace

}


