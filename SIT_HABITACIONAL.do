clear

//////////////////////////////////////////////////////////////
//  VIVIENDAS 
//////////////////////////////////////////////////////////////

clear
cd "Ruta de dtas intermedios" //ruta
  
// VIVIENDAS : Añadir un append para el nuevo año

use "2019-hogares" , clear // master
append using "2020-hogares" //using
append using "2021-hogares" //using
append using "2022-hogares" //using
append using "2023-hogares" //using

* exportar a archivo CSV !!!






cls
clear

//////////////////////////////////////////////////////////////
//  HOGARES 
//////////////////////////////////////////////////////////////

*Una base por año que junte todas las variables de interés extraídos de distintos módulos


* Adecual el intervalo de años !
forvalues a=2019/2023 {

clear
cd "Ruta de dtas intermedios" //ruta

use `a'-hogares.dta , clear

cd "Ruta de dtas intermedios" //ruta
merge 1:1 conglome vivienda hogar using `a'-sum.dta
drop _merge

merge 1:1 conglome vivienda hogar using `a'-m500.dta
drop _merge

merge 1:1 conglome vivienda hogar using `a'-m200.dta
drop _merge

save `a'-hogares.dta, replace
	}
	



* Una base general de todos los años y todas las variables de interés
clear
cd "Ruta de dtas intermedios" //ruta


// HOGARES : Añadir un append para el nuevo año
use "2019-hogares" , clear // master
append using "2020-hogares" //using
append using "2021-hogares" //using
append using "2022-hogares" //using
append using "2023-hogares" //using


*  FUENTES
***********
forvalues n=1/10 {
	if `n'==5{
	continue
	}

	gen FUENTE_`n' ="no"
	replace FUENTE_`n' = "sí" if D1F`n'==1
	replace FUENTE_`n' = "sí" if D2F`n'==1
	replace FUENTE_`n' = "sí" if D3F`n'==1
	replace FUENTE_`n' = "sí" if D4F`n'==1
	replace FUENTE_`n' = "" if D1F`n'==.  & D2F`n'==. & D3F`n'==. & D4F`n'==.
}


* exportar a archivo CSV !!!

