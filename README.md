# TIER-1-Toolbox

TIER-1 Toolbox es un módulo diseñado para SIMA en el marco del proyecto Google Challenge, para estimar los impactos acumulativos que generan las grandes centrales hidroeléctricas en el sistema fluvial de una cuenca hidrográfica.\
Este modulo tiene la capacidad de calcular los siguientes indicadores:

•	Fragmentación de la red fluvial\
•	Grado de regulación de caudal liquido (DOR)\
•	Grado de regulación de caudal liquido Ponderado (DORw)\
•	Grado de regulación de caudal solido (SAI)\
•	Huella 

## Marco Conceptual

En el espíritu de la búsqueda de soluciones equilibradas, en los últimos años, a nivel global han surgido una serie de propuestas de evaluación temprana de los conflictos ambientales y sociales regionales que generalmente afectan la sostenibilidad del sector hidroeléctrico. Entre estas soluciones se encuentra la perspectiva metodológica de Hidroenergía por Diseño ha sido desarrollada por TNC en los últimos años con objetivo es generar una respuesta de solución integral para balancear la generación de energía hidroeléctrica y la conservación de los ríos y los beneficios que generan a la sociedad a partir de la implementación de la Jerarquía de la Mitigación (evitar, minimizar y compensar impactos del sector), promoviendo principalmente un proceso de planificación temprana e integral del desarrollo hidroeléctrico a escala de cuenca con la participación de los actores relevantes, con el propósito de evaluar las posibles alternativas de desarrollo a futuro para reducir los riesgos ambientales y sociales.
Principalmente los análisis han sido centrados a tres tipos de impactos que genera el sector hidroenergético: i) La fragmentación de sistemas fluviales, ii) los efectos aguas abajo asociados a los cambios de régimen de caudales y sedimentos y iii) la huella de la inundación de los embalses sobre valores ambientales, sociales y/o culturales en la cuenca.

<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Alternativas_impacto_acumulativo.png" width="556" height="712" />

### Red topológica fluvial

Se define como red topológica fluvial a la representación geométrica de una red natural de ríos, la cual se compone por un conjunto de nodos interconectados por un tramo o segmento común (Ver Figura 18)

<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Red_topologica.png" width="248" height="221" />
Figura 18. Representación Esquemática de una Red Topológica.

### Área de drenaje

Se define como área de drenaje a el área aferente a un segmento o tramo particular de una red topológica fluvial, cuyo trazado cumple con el concepto de cuenca hidrográfica.

<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Red_topologica_are_drenaje.png" width="393" height="152" />
Figura 19. Representación Esquemática de una Red Topológica (Margen Izquierda) y un Área de Drenaje (Margen derecha).

## Apéndice B - Indicadores

### Fragmentación de la red fluvial

La fragmentación de sistemas fluviales se refiere a la pérdida de conectividad natural dentro y entre los sistemas fluviales, lo que limita los procesos naturales fundamentales para el funcionamiento de los ecosistemas como lo son la transferencia de organismos, sedimentos y nutrientes.

<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Frag.jpg" width="1000" height="300" />

Figura 20. Esquema del análisis de fragmentación basado en la perdida de longitud total de ríos libres. (a) red fluvial principal (b). Red fluvial asociada a un proceso con una distribución espacial específica (e.g. la migración de peces).
Fuente: Adaptado de (Opperman, Grill, and Hartman 2015)

En este contexto, el índice de fragmentación de sistemas fluviales permite cuantificar de manera porcentual la perdida de red fluvial asociada a un proceso natural específico como, por ejemplo, tramos fluviales asociados a un ecosistema ribereño, el rango de migración de peces, etc. Matemáticamente éste índice se define como:

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{P}_{c,i}=\left(1-\frac{{L}_{i}}{{L}_{0,i}}\right&space;)*100"/>

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{P}_{c,i}"/>	Porcentaje de pérdida de la red de drenaje asociada al proceso de interés i.
<img src="https://latex.codecogs.com/svg.latex?\Large&space;{L}_{0}"/>	Longitud de la red de drenaje asociada al proceso i, en la condición de línea base.
<img src="https://latex.codecogs.com/svg.latex?\Large&space;{L}_{i}"/>	Longitud de la red de drenaje asociada al proceso i.
Es importante tener en cuenta que este índice supone que la construcción de presas de mediana y gran escala, así como los proyectos que operan a filo de agua o que realizan desviaciones que reducen sustancialmente el caudal en tramos extensos de ríos, reducen la conectividad longitudinal debido a su efecto de barrera.

### Grado de regulación de caudal liquido (DOR)

El grado de regulación o DOR (por sus siglas en inglés: Degree of Regulation) permite cuantificar de manera porcentual, la alteración que sufre el régimen de caudales bajo la presencia de embalse. Matemáticamente este índice se define como la relación entre el volumen de almacenamiento disponible aguas arriba de un tramo fluvial i y el volumen de escorrentía media anual en el tramo i. Por lo tanto, corresponde al porcentaje de la oferta hídrica anual que es retenida en embalses localizados aguas arriba del tramo analizado i (Lehner et al., 2011):

<img src="https://latex.codecogs.com/gif.latex?{DOR}_{k}=\left(\frac{{V}_{Acum,k}}{{Esc}_{k}}\right&space;)*100" title="{DOR}_{k}=\left(\frac{{V}_{Acum,k}}{{Esc}_{k}}\right )*100" /></a>

El DOR es útil como una aproximación de la extensión y magnitud de los impactos acumulativos en el régimen de caudales. A mayores valores del DOR indican una mayor alteración de la estacionalidad del régimen de flujo natural por el efecto regulador de los embalses. Por ejemplo, un valor de DOR igual al 100% significa que aguas arriba de un tramo fluvial i es posible almacenar un volumen de agua equivalente a un año de escorrentía media.

<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/DOR.jpg" width="400" height="300" />

Figura 21. Esquema de la representación espacial del indicador de Grado de Regulación - DOR, asociado a un proyecto hidroeléctrico, donde se ilustran las diferentes longitudes de ríos aguas abajo.
Fuente: Tomado de (Opperman, Grill, and Hartman 2015)

Adicionalmente, dado que se estima en cada uno de los tramos de la red topológica fluvial, para una configuración dada de embalses en la cuenca, permite establecer la longitud de ríos afectados con diferentes grados de regulación (ver Figura 21).

### Grado de regulación de caudal liquido ponderado (DOR)
<img src="https://latex.codecogs.com/svg.latex?\Large&space;x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />

### Grado de regulación de caudal solido (SAI)

Este índice permite cuantificar las alteraciones relacionadas con el cambio en la carga de sedimentos suspendidos (SST) considerando los efectos acumulativos de captura de sedimentos de los embalses de una macrocuenca. Matemáticamente se expresa como:

<img src="https://latex.codecogs.com/svg.latex?\Large&space;SAI=\left(1-\frac{{Q}_{s,e}}{{Q}_{s,0}}\right&space;)*100"/>

Donde:
<img src="https://latex.codecogs.com/svg.latex?\Large&space;{P}_{s}"/> Porcentaje de perdida acumulativa de caudal solido medio en un tramo fluvial

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{{Q}_{s,e}}"/>	Carga media de sedimentos suspendidos en el escenario analizado considerando la retención acumulada aguas arriba.

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{{Q}_{s,0}}"/>	Carga media de sedimentos suspendidos en el escenario de referencia (sin embalses).

## Impactos directos por la huella del Proyecto (área inundada)

El tercer grupo de impactos acumulativos se refiere a la huella de las áreas de inundación de los embalses sobre sitios o áreas de valor social, ambiental y económico, entre otros: centros poblados, zonas productivas, sitios patrimoniales, áreas de interés de conservación, etc. Las variables a analizar dependen en gran medida de la información disponible y de los valores relevantes de la cuenca hidrográfica analizada. En el caso de la Macrocuenca Magdalena-Cauca se propone un análisis de los impactos de huella a partir de siete componentes generales:\
•	Demografía: cuantificación de la población que vive en el área de inundación. Constituye el grupo humano que sería necesario reubicar para el desarrollo del proyecto.\
•	Economía: cuantificación de las áreas de tierras productivas agropecuarias que se cruzan con el área de inundación, como también de los títulos mineros vigentes. Corresponden a zonas productivas perdidas, que también serán objeto de procesos de indemnización.\
•	Territorios colectivos de comunidades étnicas: cuantificación de los territorios colectivos titulados de comunidades negras  y resguardos indígenas que se localizan en el área de inundación. Constituyen grupos objeto de consulta previa y para los cuales es preciso adoptar planes específicos de prevención, atención y protección.\
•	Postconflicto: cuantificación de las áreas de zonas de microfocalización que se encuentran dentro del área de inundación. Son zonas en donde la Unidad de Restitución de Tierras ha priorizado acciones para llevar a cabo el proceso de restitución de tierra.\
•	Áreas de valor ambiental -  sistemas terrestres: Ecosistemas Estratégicos como Bosque seco tropical, páramos y humedales y áreas protegidas declaradas.\
•	Emisiones de carbono: Cuantificación de las emisiones de carbono debido a la transformación de las áreas de bosque a áreas inundadas.\
•	Biodiversidad: Cuantificación de áreas ocupadas por especies amenazadas y áreas con aves, mamíferos, reptiles y anfibios.\
<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Analisis_impactos_huella.png" width="380" height="268" />

Figura 13.  Esquema de análisis de impactos de huella para un proyecto.

### Huella

<img src="https://latex.codecogs.com/svg.latex?\Large&space;x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" title="\Large x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}" />

## Modelo de Caudales Medios Anuales Multianuales

En el presente apéndice se describe el esquema metodológico con el cual se abordó la identificación de los caudales medios anuales multianuales para cada una de las áreas de drenaje que componen la macrocuenca Magdalena-Cauca (Ver Apéndice C - Red Topológica fluvial), así como también la información utilizada y modelos implementados.

### Sedimentos

Para la estimación de <img src="https://latex.codecogs.com/svg.latex?\Large&space;{{Q}_{s,0}}"/>, se tomaron como base los resultados obtenidos en el documento “Estudio y desarrollo de herramientas para modelación de sedimentos y de dinámica de inundación como complemento a la modelación hidrológica en WEAP” (Gotta, TNC, 2016), donde se estimó el rendimiento en la producción de sedimentos en suspensión de la cuenca Magdalena, mostrado en la Figura 27.
 
Figura 27. Rendimiento de la producción de sedimentos de la cuenca Magdalena Cauca. Tomado de (Gotta, TNC, 2016)

A nivel conceptual, la Figura 28 presenta esquemáticamente las fuentes y sumideros de sedimentos considerados para el balance.
 
Figura 28. Fuentes y sumideros de sedimento en el balance de sedimentos de un tramo de corriente.

La estimación de los aportes de sedimentos generados por erosión en las laderas se realizó a través de la metodología RUSLE (Revised Universal Sol Loss Equation) desarrollada por el servicio de conservación de suelos de los Estados Unidos. La ecuación de cálculo se presenta a continuación.

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{E}_{x}=R*K*LS*C*P"/>

Donde <img src="https://latex.codecogs.com/svg.latex?\Large&space;{E}_{x}"/> es la erosión laminar, R la erosividad de la lluvia, K la erodabilidad del suelo, LS el factor topográfico, C las coberturas del suelo y P las prácticas de manejo del mismo. 
La erosión en cárcavas se refiere a los aportes de sedimentos causados por procesos de incisión y ensanchamiento de las líneas de drenaje. Conceptualmente, la estimación de estos aportes considera el volumen de las cárcavas y el período de tiempo para su desarrollo. Su estimación se realiza a partir de la siguiente expresión.

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{G}_{x}="/>

Donde <img src="https://latex.codecogs.com/svg.latex?\Large&space;{\rho}_{s}"/> es la densidad aparente seca del sedimento característico de las cárcavas, <img src="https://latex.codecogs.com/svg.latex?\Large&space;{p}_{b}"/> es la proporción de material que contribuye al sedimento en suspensión, α es el área transversal media de la(s) cárcava(s) de la sub-cuenca o ladera, <img src="https://latex.codecogs.com/svg.latex?\Large&space;{L}_{x}"/> es la longitud de la(s) cárcava(s) de la sub-cuenca o ladera y f es un factor (<1) a partir del cual puede modularse el aporte de sedimentos dependiendo de la actividad o madurez del proceso erosivo.

Para la estimación de los aportes por erosión en banca, se utilizó la expresión de Wilkinson et al. (2009)

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{B}_{x}="/>

Donde 〖B_x es la tasa de erosión lateral (m/año), <img src="https://latex.codecogs.com/svg.latex?\Large&space;{\rho}_{s}"/> es la densidad aparente seca del sedimento característico de las márgenes del tramo, <img src="https://latex.codecogs.com/svg.latex?\Large&space;{p}_{b}"/> es la proporción de material que contribuye al sedimento en suspensión, h es la profundidad media de banca llena del tramo y <img src="https://latex.codecogs.com/svg.latex?\Large&space;{L}_{x}"/> es la longitud del tramo.

Para la modelación de depositación en llanuras, se asume que la proporción de sedimento en suspensión <img src="https://latex.codecogs.com/svg.latex?\Large&space;{I}_{x}"/> que ingresa al tramo que es posteriormente liberada en la llanura de inundación para cada evento es igual a la proporción del caudal desbordado <img src="https://latex.codecogs.com/svg.latex?\Large&space;\frac{Q-{Q}_{B}}{Q}"/> donde <img src="https://latex.codecogs.com/svg.latex?\Large&space;{Q}_{B}"/> es el caudal de banca llena y Q el caudal total, depositación de sedimento (en toneladas por evento). El cálculo se realiza mediante la siguiente expresión.

<img src="https://latex.codecogs.com/svg.latex?\Large&space;{F}_{x}=I"/>

Donde <img src="https://latex.codecogs.com/svg.latex?\Large&space;{A}_{f}"/> es el área de la llanura de inundación y _s es la velocidad de sedimentación de partícula.
Por otra parte, la estimación la retención en embalses (aplicable al escenario analizado <img src="https://latex.codecogs.com/svg.latex?\Large&space;{Q}_{s,e}"/>), se aplica la expresión de Dendy para estimar la eficiencia media de atrapamiento como:

E=100

Donde E es la eficiencia de atrapamiento, I es el caudal medio anual y C es la capacidad del embalse. Esta expresión se basa en la relación empírica propuesta por Brune (Ver Figura 29).
 
Figura 29. Curva de eficiencia de atrapamiento de Brune.
(Fuente: U.S. Army Corps of Engineers)
 
Figura 30. Fuentes y sumideros de sedimento en el balance de sedimentos de un tramo de corriente (Aproximación de Primer Nivel).
Fuente: (Gotta, TNC, 2016)

Considerando la información disponible, para los propósitos de este informe, se desarrolla un análisis de primer nivel, adoptando un esquema simplificado con fuentes en aportes de tributarios (Tx) y erosión de ladera (Hx) y sumideros en la retención en embalses con la ecuación de Dendy (Rx) (Ver Figura 30).



### Caudales

El modelo planteado para la estimación de los caudales medios anuales multianuales de las áreas de drenaje que componen la macrocuenca Magdalena Cauca, correspondió al propuesto por Turc. Éste considera que el caudal medio anual multianual en un afluente es el resultado del diferencial entre la precipitación media anual multianual (mm) y la evapotranspiración real media mensual multianual (mm). Matemáticamente este modelo resultar ser:

<img src="https://latex.codecogs.com/gif.latex?Q=(P-ETR)" title="Q=(P-ETR)" /></a>

Dada la modesta cantidad de estaciones con la que cuanta la macrocuenca Magdalena-Cauca con capacidad de estimar evapotranspiraciones reales, se optó por realizar su estimación mediante el modelo propuesto por este mismo autor. El modelo propuesto por Turc para determinar la evapotranspiración real, se basa en una relación empírica entre la precipitación y la temperatura, cuya verificación fue realizada en un total de 254 cuencas. Matemáticamente el modelo se define como:

<img src="https://latex.codecogs.com/gif.latex?ETR=\frac{P}{\sqrt[2]{0.9&plus;/\frac{P^{2}}{L(t)^{2}}}}" title="ETR=\frac{P}{\sqrt[2]{0.9+/\frac{P^{2}}{L(t)^{2}}}}" /></a>

Donde P es la precipitación media anual multianual expresada en mm y la expresión L(t) se define como:

<img src="https://latex.codecogs.com/gif.latex?L(t)=300&plus;25T&plus;0.05T^{2}" title="L(t)=300+25T+0.05T^{2}" /></a>

Donde T es la temperatura media anual multianual del aire en °C. El modelo de Turc es válido si se cumple la siguiente condición:
<img src="https://latex.codecogs.com/gif.latex?\frac{P}{L}\geq&space;0.316" title="\frac{P}{L}\geq 0.316" /></a> caso contrario: <img src="https://latex.codecogs.com/gif.latex?ETR=P" title="ETR=P" /></a>

Ahora bien, reconociendo que existe una incertidumbre asociada a la estimación de la ETR mediante el modelo de Turc (producto de la complejidad de los procesos físicos que la rigen los procesos transpirativos principalmente), se consideró parametrizar este modelo, mediante un parámetro Alpha, dado lugar a una ETR corregida definida como:

<img src="https://latex.codecogs.com/gif.latex?ETR_{c}=ETR*\alpha" title="ETR_{c}=ETR*\alpha" /></a>

Vale la pena resaltar que, para el modelo de balance hidrológico, este planteamiento supone que la precipitación es totalmente correcta y que solo el error en el balance se encuentra asociado a la ETR.

### Esquema de calibración y evolución del modelo hidrológico

La calibración del modelo de caudales se realizó mediante un esquema acumulativo. Este consistió en aplicar el modelo plantado anteriormente sobre el área aferente a las estaciones objeto de calibración, asignado en esta los parámetros calibrados. No obstante, dicha área es limitada si existe una estación aguas arriba de la misma, quedando solo el área aferente hasta el encuentro con el área aferente de la estación aguas arriba.

Para ejemplificar un poco esto, observemos la Figura 25. En esta se logra apreciar una cuenca segmentada en 30 áreas de drenaje, las cuales se encuentran asociada a los tramos de la red topológica. En ella existen 3 estaciones, cuyas áreas aferentes se demarca por un color diferente. Particularmente se observa que la última estación (rombo rojo) la cual pose como área aferente toda la cuenca, se encuentra limitada hasta la confluencia con las dos estaciones aguas arriba de esta. En este orden de ideas, la calibración se iniciaría por las estacione 1 y 2, se asignaría los parámetros de cada una a las áreas de drenaje que se encuentren contenidas sobre su área aferentes. Luego se realizaría la calibración de las áreas pertinentes al área aferente de la estación 0, utilizando los parámetros de las anteriormente calibradas y asignando los parámetros encontrados solo a las pertenecientes a dicha estación.

<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Areas_aferentes.png" width="172" height="227" />

Figura 25. Representación esquemática de las áreas aferentes asociadas a cada estacione objeto de calibración.

Como se logra visualizar en la Figura 24 – B, existen áreas de drenaje las cuales no se encuentran asociadas a ninguna estación. En estos casos lo que se hizo fue considerar que la evapotranspiración calculada mediante el modelo propuesto corresponde a la real, lo que implica que el parámetro para dichas áreas de drenaje tomase un valor igual a uno.

Como métrica de desempeño del modelo, se consideró el coeficiente de Nash-Sutcliffe (Ver los trabajos de Teegavarapu & Elshorbagy (2005) y Dawson, Abrahart and See, (2007)), cuya expresión matemática es:

<img src="https://latex.codecogs.com/gif.latex?Nash=1-\frac{\sum_{i=1}^{n}(x_{0}^{t}-x_{m}^{t})^{2}}{\sum_{i=1}^{n}(x_{0}^{t}-{\bar{x}}_{0})^{2}}" title="Nash=1-\frac{\sum_{i=1}^{n}(x_{0}^{t}-x_{m}^{t})^{2}}{\sum_{i=1}^{n}(x_{0}^{t}-{\bar{x}}_{0})^{2}}" /></a>

Dónde

<img src="https://latex.codecogs.com/gif.latex?x_{0}^{t}" title="x_{0}^{t}" /></a>	Valor observado.

<img src="https://latex.codecogs.com/gif.latex?x_{0}^{t}" title="x_{m}^{t}" /></a>	Valor simulado.

<img src="https://latex.codecogs.com/gif.latex?\bar{x}}_{0}" /></a> Valor promedio.

Esta métrica varía desde -∞ hasta 1. Cuando el coeficiente de Nash toma un valor de 1 se considera que la calibración del modelo fue perfecta. Los rangos para evaluar el nivel de ajuste con esta métrica se presentan en la Tabla 2.

Tabla 2. Rangos para evaluar el desempeño de los modelos con el Nash-Sutcliffe
<img src="https://github.com/The-Nature-Conservancy-NASCA/Images_Repository/blob/master/Exploratory_Module_SIMA/Modelo_Nash-Sutcliffe.png" width="343" height="140" />\
Fuente: (Moriasi et al. 2007)

## Entradas del Modulo

ControlFile_Matlab
```
# Path Root Folder
# --------------------
* D:\TNC\Project\Project-SIMA\SIMA-Explorer-Module\Adapter\SIMA_WGS84\Root_Folder

# --------------------
# Path DEM
# --------------------
* D:\TNC\Project\Project-SIMA\SIMA-Explorer-Module\Adapter\SIMA_WGS84\DEM\DEM.tif

# --------------------
# Path Rasters - Footprints
# --------------------
* D:\TNC\Project\Project-SIMA\SIMA-Explorer-Module\Adapter\SIMA_WGS84\Rasters_Footprints

# --------------------
# Path BinFiles_Matlab
# --------------------
* D:\TNC\Project\Project-SIMA\SIMA-Explorer-Module\Adapter\SIMA_WGS84\BinFiles_Matlab

# --------------------
# Threshold for Flow Accumulation (Cells number)
# This Parameters depend of the Digital elevation model resolution
# --------------------
* 50
```

ControlFile_SIMA
```
# User Name
# -------------------------------------------
* admin

# -------------------------------------------
# Number or Name of the Execution
# -------------------------------------------
* Execution-001

# -------------------------------------------
# Analysis Code
#   1 -> DOR - DORw
#   2 -> SAI
#   3 -> DOR - DORw + SAI
#   4 -> Fragmentation
#   5 -> Fragmentation + DOR + DORw
#   6 -> Fragmentation + SAI
#   7 -> Fragmentation + DOR + DORw + SAI
# -------------------------------------------
* 1

# -------------------------------------------
# Footprint Status [0 -> False] [1 -> True]
# -------------------------------------------
* 1

# -------------------------------------------
# Explorer Status [0 -> False] [1 -> True]
# -------------------------------------------
* 0
```

## Salidas del Modulo
## Configuración del módulo en SIMA

Si se cambia el modelo de levacion digital o las capas de huella asi estas tengan el mismo nombre se debe borrar la capeta de los binarios. Los binarios se crean para ahorrar el tiempo de computo.

## Interpretación de Salidas
## Links de Interes
## Referencias
