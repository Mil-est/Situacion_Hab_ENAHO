clear
cls
cd "G:\2024\PLANEAMIENTO Y PROSPECTIVA\06. PROYECTOS\09. Situación Habitacional\02. Modificaciones\ADICIONES 2"


//     Importar bases de datos 
//     MODULO 100 - 2021 

unicode analyze "enaho01-2019-100.dta" 
unicode encoding set "latin1"
unicode translate "enaho01-2019-100.dta" 
use "enaho01-2019-100.dta"



gen FUENTE_CREDITO = 0
forvalue x= 1/10 {
	if `x'==5{
			continue
			}	
	replace FUENTE_CREDITO = `x' if p107c1`x'==`x'| p107c2`x'==`x' | p107c3`x'==`x'| p107c4`x'==`x'
	replace FUENTE_CREDITO =. if p107c1`x'==. & p107c2`x'==. & p107c3`x'==. & p107c4`x'==.
}

* etiquetas de categorías
label var FUENTE_CREDITO fuentes_fin
label define fuentes_fin 1 "Banco privado" 2 "Banco de la Nación" 3 "Caja Municipal" 4 "Persona Particular" 6 "Techo Propio" 7 "Financiera de Ahorro y Crédito" 8 "Otros" 9 "Cooperativa de ahorro y crédito" 10 "Derrama Magisterial"
label values FUENTE_CREDITO fuentes_fin

tab FUENTE_CREDITO [iw=factor07]




//  Manejo de datos y  Generador de indicadores
// ______________________________________________


egen idhogar = concat(conglome vivienda hogar)
duplicates tag idhogar , gen (duplicado)
tab duplicado
drop duplicado

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




*==================================*
*  SECCIÓN I: PARQUE HABITACIONAL
*==================================*


// TIPO DE VIVIENDA
//------------------
tab p101
rename p101 TIPO_VIVIENDA
tab TIPO_VIVIENDA [iw=factor07]


// HOGARES SEGÚN RÉGIMEN DE TENENCIA DE LA VIVIENDA
//-----------------------------------------------------

rename p105a REGIMEN_TENENCIA_VIV 
tab REGIMEN_TENENCIA_VIV [iw=factor07]


// HOGARES QUE POSEEN TÍTULO DE PROPIEDAD
//-------------------------------------------

*tab p106a
rename p106a TITULO_DE_PROPIEDAD
tab TITULO_DE_PROPIEDAD [iw=factor07]


// registrado en SUNARP:
//------------------------

rename p106b TITULO_REGISTRADO_SUNARP
tab TITULO_REGISTRADO_SUNARP [iw=factor07]




*=================================*
*  SECCIÓN III: SERVICIOS BÁSICOS
*==================================*


// HOGARES CON ACCESO A ALUMBRADO ELÉCTRICO
//------------------------------------------

la var p1121 "electricidad" 
label define electricidad 0 "no" 1 "si", modify
la values p1121 electricidad

rename p1121 ALUMBRADO_ELECTRICO
tab ALUMBRADO_ELECTRICO [iw=factor07]

// HOGARES CON ACCESO A SERVICIO DE AGUA
//----------------------------------------

rename p110 PROCEDENCIA_SERVICIO_AGUA
tab PROCEDENCIA_SERVICIO_AGUA [iw=factor07]

// HOGARES CON ACCESO A ALCANTARILLADO
//--------------------------------------

rename p111a ACCESO_ALCANTARILLADO
tab ACCESO_ALCANTARILLADO [iw=factor07]

// COMBUSTIBLE MÁS UTILIZADO PARA COCINAR EN EL HOGAR
//-----------------------------------------------------

rename p113a COMBUSTIBLE_PARA_COCINA
tab COMBUSTIBLE_PARA_COCINA [iw=factor07]



*=============================================*
*  SECCIÓN IV: FINANCIAMIENTO PARA VIVIENDA
*=============================================*


* Obtención de crédito hipotecario
gen ACCESO_FIN = 0
replace ACCESO_FIN = 1 if p107b1==1 | p107b2==1 | p107b3==1 | p107b4==1
replace ACCESO_FIN = . if p107b1==. & p107b2==. & p107b3==. & p107b4==.
	
la var ACCESO_FIN "credito" 
label define credito 0 "no" 1 "si"
la values ACCESO_FIN credito

tab ACCESO_FIN [iw=factor07]

	
// DIFICULTADES EN EL CRONOGRAMA DE PAGO DEL CRÉDITO
//----------------------------------------------------

rename p107e DIFICULTADES_PAGO_CREDITO
tab DIFICULTADES_PAGO_CREDITO [iw=factor07]


// MONTO DE CRÉDITO PROMEDIO segun destino del crédito
//------------------------------------------------------

**Monto Total del Crédito recibido

*	sum p107d1 //destinado a: Comprar casa, departamento
*	sum p107d2 //destinado a:Comprar TERRENO PARA vivienda
*	sum p107d3 //destinado a:Mejoramiento y/o ampliación            
*	sum p107d4 //destinado a: Construcción de vivienda nueva

	* Visualizacion de los datos
	tabstat p107d1 p107d2 p107d3 p107d4, stat (mean)  	
	tabstat p107d1 p107d2 p107d3 p107d4  [aw=factor07], stat (mean)


// FUENTE DEL FINANCIAMIENTO
//-----------------------------------------------------------------------------
	
//FUENTES
forvalues n=1/10 {
	if `n'==5{
	continue
	}
//DESTINOS
	 forvalues r=1/4 {
	 	gen D`r'F`n' =.
		replace D`r'F`n'=0 if p107c`r'`n'==0
		replace D`r'F`n'=1 if p107c`r'`n'==`n'
	}
	}
	


*=================================*
*  SECCIÓN III: OTROS
*==================================*

tab nbi3
rename nbi3 NBI3_VIV_SINSSHH
tab nbi4
rename nbi4 NBI24_NIÑOS_NO_ESCUELA
tab nbi5
rename nbi5 ALTA_DEPEND_ECON












// AÑO
gen AÑO = 2019

*Verificando que no haya hogares duplicados
duplicates tag idhogar , gen (duplicado)
tab duplicado
drop duplicado

tab result
drop if result==3 | result==4 | result==5 | result==7




//variables de interés
keep conglome vivienda hogar idhogar idvivienda ubigeo dominio AREA REGION_NATURAL TIPO_VIVIENDA DEPARTAMENTOS AÑO factor07 REGIMEN_TENENCIA_VIV TITULO_DE_PROPIEDAD TITULO_REGISTRADO_SUNARP ALUMBRADO_ELECTRICO PROCEDENCIA_SERVICIO_AGUA ACCESO_ALCANTARILLADO COMBUSTIBLE_PARA_COCINA ACCESO_FIN DIFICULTADES_PAGO_CREDITO p107d1 p107d2 p107d3 p107d4 FUENTE_CREDITO D1F1 D2F1 D3F1 D4F1 D1F2 D2F2 D3F2 D4F2 D1F3 D2F3 D3F3 D4F3 D1F4 D2F4 D3F4 D4F4 D1F6 D2F6 D3F6 D4F6 D1F7 D2F7 D3F7 D4F7 D1F8 D2F8 D3F8 D4F8 D1F9 D2F9 D3F9 D4F9 D1F10 D2F10 D3F10 D4F10 p107b1 p107b2 p107b3 p107b4 NBI3_VIV_SINSSHH NBI24_NIÑOS_NO_ESCUELA ALTA_DEPEND_ECON
		  
save "2019-hogares.dta", replace
