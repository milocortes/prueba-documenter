# [CMIP6](@id cmip_data)

## Introducción

Para el cálculo de parámetros climáticos, necesitamos los siguientes datos climáticos para las tres macro-regiones:
* Total atmospheric mass of co2 (co2mass)
* Mole fraction of co2 (co2)
* Near surface air temperature (tas)

Estos datos se encuentran disponibles por el [Earth System Grid Federation (ESGF)](https://esgf.llnl.gov/), la cual es una red federada de centros de datos académicos y gubernamentales en EUA, Europa y Asia. La organización es la fuente principal de acceso a datos clímatos del [Coupled Model Intercomparison Project (CMIP)](https://www.wcrp-climate.org/wgcm-cmip), el cual es un proyecto que proporciona proyecciones climáticas permitiendo la intercomparación de modelos acomplados. Los modelos acomplados son aquellos que modelan la atmósfera y el océano de forma integrada para el entender el sistema clíma en su conjunto. 

El CMIP conjunta los resultados de distintos grupos de modelación, los cuales son producto de diferentes experimentos numéricos. La comparación de los resultados de los modelos no tiene certeza sobre si las diferencias de resultados son producto de diferencias en los modelos o a su configuración (diseño experimental).  El CMIP se diseñó como un medio para armonizar los experimentos de los grupos de modelación para saber si los modelos están configurados de la misma forma. Esto permite identificar los procesos particulares a los modelos para comprender qué está causando las diferencias.

De forma periódica (aproximadamente 5 o 6 años) CMIP acuerda un conjunto de experimentos con la comunidad internacional para ser establecidos y ejecutados por los centros de modelación. El más reciente acuerdo es el de [CMIP6](https://www.wcrp-climate.org/wgcm-cmip/wgcm-cmip6). Los resultados de estos experimentos son analizados posteriormente en la evaluación climática del Grupo Intergubernamental de Expertos sobre el Cambio Climático o Panel Intergubernamental del Cambio Climático [(IPCC)](https://archive.ipcc.ch/home_languages_main_spanish.shtml) para su sexto reporte. 

## Búsqueda y descarga de datos

El ESGF es una red de nodos, entre los cuales se encuentra el Lawrence-Livermore National Laboratory, German Climate Computing Centre (DKRZ por sus siglas en alemán), el Pierre Simon Laplace Institute (IPSL), entre otros. 

Al ser un repositio distribuido, los datos no se encuentran centralizados de manera que es necesario realizar una búsqueda en la red de ESGF. El ESGF proporiona el paquete [`esgf-pyclient`](https://github.com/ESGF/esgf-pyclient) de python que permite el acceso a la [API](https://esgf.github.io/esgf-user-support/user_guide.html#the-esgf-search-restful-api) de búsqueda de ESGF.  En el siguiente [link](https://claut.gitlab.io/man_ccia/lab2.html) se presenta un tutorial de cómo utilizar este paquete.  

Dado que el análisis se realizó a nivel de macro-regiones, necesitamos una granularidad más fina de los datos. Por tal motivo, para la búsqueda de los datos fue imprecindible contar con los datos que proporcionaran los raster que tuvieran cobertura para las tres macroregiones.  Fueron dos los modelos que fue posible detectar y descargar dichos datos:

* [CESM2-WACCM](https://www.cesm.ucar.edu/models/waccm-x/)
* [GFDL-ESM4](https://www.gfdl.noaa.gov/earth-system-esm4/)  

El siguiente programa utiliza la biblioteca `esgf-pyclient` para la búsqueda de los datos:

```python
from pyesgf.search import SearchConnection
from tqdm import tqdm
import pandas as pd

df_result_total = pd.DataFrame()


gcm_models = ['BCC-CSM2-MR','BCC-EM1','CanESM5','CESM2','CESM2-WACCM','CNRM-CM6-1','CNRM-ESM2-1','EC-EARTH3-Veg','GFDL-ESM4','GFDL-CM4','IPSL-CM6A-LR','MRI-ESM2-0','NorESM2-LM','SAM0-UNICON','UKESM1-0-LL']

cmip_url = ["https://esgf-node.llnl.gov/esg-search",
        "https://esgf-node.ipsl.upmc.fr/esg-search",
        "https://esgf-data.dkrz.de/esg-search",
        "https://esgf-index1.ceda.ac.uk/esg-search"]

rcps = ['historical','ssp126','ssp245','ssp370','ssp585']

climate_variables = ['co2mass','co2','tas']

for url_node in cmip_url:
    print("############################################################3")
    print("Búsqueda en la liga {}".format(url_node))
    conn = SearchConnection(url_node, distrib=True)
    print("############################################################3")

    for model in tqdm(gcm_models):
        for rcp in rcps:
            for clim_var in climate_variables:
                ctx = conn.new_context(
                    project='CMIP6',
                    frequency='mon',
                    source_id=model,
                    experiment_id=rcp,
                    variant_label='r1i1p1f1',
                    variable=clim_var)

                if ctx.hit_count > 0:

                    df_result_parcial = pd.DataFrame().from_dict({"climate_model" : [model],
                                                                    "rcp" : [rcp],
                                                                    "climate_variable":[clim_var]})
                    print("Nodo: {}\nModelo: {}\nRCP: {}\nVariable climática: {}".format(url_node,model,rcp,clim_var))
                    for i in tqdm(range(len(ctx.search()))):
                        try:
                            result = ctx.search()[i]
                            files = result.file_context().search()

                            for file in files:
                                #print("Nodo: {}\nModelo: {}\nRCP: {}\nVariable climática: {}\nURL: {}".format(url_node,model,rcp,clim_var,file.opendap_url))
                                #df_result_parcial["url"] = [file.opendap_url]
                                df_result_parcial["url"] = [file.download_url]
                                df_result_total = pd.concat([df_result_total,df_result_parcial])
                        except Exception as e:
                            print("Hubo un error")

df_result_total.to_csv('variant_label_r1i1p1f1.csv')

# Hacemos un subset de los modelos que cumplen con todos los datos necesarios
final_models = ['CESM2-WACCM','NorESM2-LM','GFDL-ESM4']

df_final_models = df_result_total[df_result_total["climate_model"].isin(final_models)]

# Generamos una columna de fechas
df_final_models["date"] = pd.to_datetime(df_final_models["url"].apply(lambda x: x.split("/")[-2][1:]), format='%Y%m%d')
# Generamos una columna de nodo
df_final_models["nodo"] = df_final_models["url"].apply(lambda x: x.split("/")[2])

# Generamos una columna de la perioricidad del dato
df_final_models["temporalidad"] = df_final_models["url"].apply(lambda x: x.split("/")[-1].split("_")[1])

# Nos quedamos con las últimas versiones de cada variable, rcp y modelo
final_models_last_date = []

for model in final_models:
    for nodo in set(df_final_models["nodo"] ):
        for rcp in rcps:
            for cv in climate_variables:
                parcial_final_models = df_final_models.query("climate_model == '{}' and nodo =='{}' and climate_variable=='{}' and rcp == '{}' and temporalidad=='Amon'".format(model,nodo,cv,rcp))

                urls = set(list(parcial_final_models[parcial_final_models["date"]== parcial_final_models["date"].min()]["url"]))

                for url in urls:
                    final_models_last_date.append({'climate_model' : model,
                                                   'nodo' : nodo,
                                                   'rcp' : rcp,
                                                   'climate_variable' : cv,
                                                   'url' : url})

df_final_models_last_date = pd.DataFrame(final_models_last_date)

for model in final_models:
    for nodo in set(df_final_models_last_date["nodo"]):
        for cv in climate_variables:
            consulta = "climate_model=='{}' and nodo=='{}' and climate_variable=='{}'".format(model,nodo,cv)
            if set(df_final_models_last_date.query(consulta)["rcp"]):
                if len(set(df_final_models_last_date.query(consulta)["rcp"]))==5:
                    print("%------------------------------------------------------%")
                    print(consulta)
                    print(set(df_final_models_last_date.query(consulta)["rcp"]))
                    print(df_final_models_last_date.query(consulta).shape)


'''
    Usaremos los siguientes nodos para los modelos:
        * CESM2-WACCM ----> esgf-data.ucar.edu
        * NorESM2-LM  ----> noresg.nird.sigma2.no
        * GFDL-ESM4   ----> esgdata.gfdl.noaa.gov
'''

def get_url_final_models(model,nodo):
    parcial = df_final_models_last_date.query("climate_model=='{}' and nodo =='{}'".format(model,nodo))

    for rcp in rcps:
        f = open("{}_{}.txt".format(model,rcp),"x")
        for url in parcial.query("rcp=='{}'".format(rcp))["url"]:
            f.write("{}\n".format(url))

        f.close()

get_url_final_models("CESM2-WACCM","esgf-data.ucar.edu")
get_url_final_models("NorESM2-LM","noresg.nird.sigma2.no")
get_url_final_models("GFDL-ESM4","esgdata.gfdl.noaa.gov")
```

Una vez que se buscaron las ligas de descarga de los datos, utilizamos el siguiente programa para descargarlos:

```shellscript
#!/usr/bin/env bash
filename='gcm-models.txt'

# Declaramos un arreglo de los rcps
declare -a rcps=("historical" "ssp126" "ssp245" "ssp370" "ssp585")

# Declaramos un arreglo de las variables climáticas
declare -a climvariables=("co2mass" "co2" "tas")

# Creamos los directorios necesarios
echo "CREAMOS LOS DIRECTORIOS NECESARIOS"
while read model; do

  if [ -d "$model" ]; then
    rm -rf "$model"
  fi

  mkdir "$model"
  cd "$model"
  for rcp in ${rcps[@]}; do

    mkdir "$rcp"
    cd "$rcp"
    for climvar in ${climvariables[@]}; do
      mkdir "$climvar"
    done
    cd ..
  done
  cd ..

done < $filename

while read model; do

  for rcp in ${rcps[@]}; do
    model_download=$model"_"$rcp".txt"

    if [ -f "$model_download" ]; then
    echo "$model_download exists."
    wget -i $model_download
    echo "***********************************"
    echo "MOVEMOS LOS NCDF AL DIRECTORIO"
    echo "./$model/$rcp/"
    echo "***********************************"

    mv *.nc "./$model/$rcp/"

    fi

  done

done < $filename
```
