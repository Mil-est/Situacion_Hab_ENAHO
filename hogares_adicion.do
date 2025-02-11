clear
cls
cd "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\03. Recursos"


//////////////////////////////////////////////////////////////////////////////////
//     MODULO 500 
//////////////////////////////////////////////////////////////////////////////////

use "enaho01a-2019-500.dta"

egen idhog = concat(conglome vivienda hogar)
duplicates report idhog


// INFORMALIDAD
//------------------
tab ocupinf
rename ocupinf INFORMALIDAD
tab INFORMALIDAD 



// AÑO
gen AÑO = 2019


// Limpiando base

tab p203, nol
keep if p203==1

keep conglome vivienda hogar AÑO  INFORMALIDAD


save "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\02. Modificaciones\ADICIONES\2019-m500.dta", replace




//////////////////////////////////////////////////////////////////////////////////
//     SUMARIAS
//////////////////////////////////////////////////////////////////////////////////
clear
cls
cd "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\03. Recursos"

use "sumaria-2023.dta"


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

// AÑO
gen AÑO = 2023

keep conglome vivienda hogar AÑO  ESTRATO_SOCIAL POBREZA


save "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\02. Modificaciones\ADICIONES\2023-sum.dta", replace








//////////////////////////////////////////////////////////////////////////////////
//     MODULO 200 
//////////////////////////////////////////////////////////////////////////////////
clear
cls
cd "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\03. Recursos"

use "enaho01-2023-200.dta"

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
gen AÑO = 2023


// Limpiando base

tab p203, nol
keep if p203==1 //info jefe de hogar

keep conglome vivienda hogar AÑO  SEXO EDAD ESTADO_CIVIL hijo_present pareja_present familiar_present  no_familiar_present trabajador_hogar_present


save "G:\2025\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\02. Situación Habitacional\02. Modificaciones\ADICIONES\2023-m200.dta", replace


