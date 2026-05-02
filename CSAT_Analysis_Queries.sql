/*VERIFICACION
Numero de registros (2764)*/
SELECT COUNT(*) AS total_registros
FROM csat_data;
/* La cantidad de registros esperada es 2760, no 2764. 
Al revisar en "Browse Data", se evidencia que, al importar el archivo CSV, se 
añadieron 4 filas nulas al final de la tabla, así que corrí la siguiente
query para eliminar los valores nulos. */
DELETE FROM csat_data
WHERE ID_Interaccion IS NULL;
--Columnas y valores unicos en "Canal"
SELECT DISTINCT Canal
FROM csat_data;

/*METRICAS CLAVE
CSAT promedio general*/
SELECT 
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS total_interacciones,
  SUM(CASE WHEN Cliente_Satisfecho = 'Sí' THEN 1 ELSE 0 END) AS satisfechos,
  ROUND(SUM(CASE WHEN Cliente_Satisfecho = 'Sí' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_satisfechos
FROM csat_data;
--CSAT promedio por mes
SELECT 
  CAST(SUBSTR(Fecha, 1, INSTR(Fecha, '/') - 1) AS INTEGER) AS mes_num,
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS interacciones
FROM csat_data
GROUP BY mes_num
ORDER BY mes_num;
--CSAT por Canal
SELECT 
  Canal,
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS interacciones,
  ROUND(SUM(CASE WHEN Cliente_Satisfecho = 'Sí' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_satisfechos
FROM csat_data
GROUP BY Canal
ORDER BY csat_promedio DESC;
--CSAT por turno
SELECT 
  Turno,
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS interacciones
FROM csat_data
GROUP BY Turno
ORDER BY csat_promedio DESC;
--CSAT por idioma
SELECT 
  Idioma,
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS interacciones
FROM csat_data
GROUP BY Idioma;

/*ANÁLISIS
Top 5 agentes con mejor CSAT*/
SELECT 
  Agente_ID,
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS interacciones
FROM csat_data
GROUP BY Agente_ID
ORDER BY csat_promedio DESC
LIMIT 5;
--5 agentes con peor CSAT
SELECT 
  Agente_ID,
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS interacciones
FROM csat_data
GROUP BY Agente_ID
ORDER BY csat_promedio ASC
LIMIT 5;
--Tipo de consulta con más clientes insatisfechos
SELECT 
  Tipo_Consulta,
  COUNT(*) AS total,
  SUM(CASE WHEN Cliente_Satisfecho = 'No' THEN 1 ELSE 0 END) AS insatisfechos,
  ROUND(SUM(CASE WHEN Cliente_Satisfecho = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_insatisfechos
FROM csat_data
GROUP BY Tipo_Consulta
ORDER BY pct_insatisfechos DESC;
--Impacto del tipo de resolución en CSAT
SELECT 
  Resolucion,
  ROUND(AVG(CSAT_Score), 2) AS csat_promedio,
  COUNT(*) AS casos
FROM csat_data
GROUP BY Resolucion
ORDER BY csat_promedio DESC;