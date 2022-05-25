# [EDIAM](@id ediam)
## Exploratory Dynamic Integrated Assessment Model (EDIAM)
#### Objetivo del modelo

* Proporcionar un análisis cuantitativo exploratorio de distintos esquemas de cooperación asociado con la arquitectura del GCF.
* Se enfoca principalmente en la evaluación tecnológica de países avanzados y emergentes y en el efecto que las intervenciones de política tienen en la mitigación del cambio climático y del crecimiento económico.

El modelo proporciona una representación abstracta y simplificada en un contexto multipaís en el que se da lugar el cambio tecnológico dirigido. El modelo tiene como fin el análisis exploratorio cuantitativo de la difusión de largo plazo de tecnologías de energías renovables (SET) y análizar el desempeño de distintas arquitecturas de cooperación.

El modelo supone dos regiones:
* Una tecnológicamente avanzada 
* Una emergente  tecnológicamente atrasada

La producción de energía en ambas regiones se realiza mediante una combinación de dos ofertas de energía primaria:

* Energía fósil, ``Y_{fe}``
* Energía sostenible, ``Y_{se}``	

El uso de energía fósil en ambas regiones contribuye a la degradación del ambiente de la siguiente manera:

```math
\begin{align}
\frac{\partial S}{\partial t} = - \xi  \big( Y(t)_{fe}^{A} + Y(t)_{fe}^{E}\big) + \delta S(t)
\end{align}
```

donde:
* ``S`` es la calidad de ambiente.
* ``\xi`` es el daño marginal al ambiente por unidad de energia fósil usada en ambas regiones.
* ``\delta`` es la tasa promedio de regeneración ambiental

 
La emisión de ``CO_2`` es función de la calidad del ambiente:

```math
\begin{align}
CO_2(t)= CO_{2|6.0°C}- S(t)
\end{align}
```

Donde ``CO_{2|6.0°C}`` es el nivel de emisiones de ``C0_2`` que llevarían al incremento del ``6.0°C`` 

La temperatura evoluciona de la siguiente forma:

```math
\begin{align}
\Delta T(t)= \beta \; ln \dfrac{CO_2(t)}{CO_{2,0}}
\end{align}
```

Donde ``CO_{2,0}`` es el nivel inicial de concentración en la atmósfera de ``C0_2`` al inicio de siglo XX.
