

select distinct 
     dimSKPeticao, tmp.NumDeposito
INTO #TMP_SOURCE from (SELECT DISTINCT CodServico
			  , DescServico
			  , NumProtocolo
			  , NomeCliente
			  , GrupoServico
			  ,NumDepositoInpi as NumDeposito
INTO #TMP_SOURCE
FROM ods.InpiMarca
UNION
SELECT DISTINCT CodServico
			  , DescServico
			  , NumProtocolo
			  , NomeCliente
			  , GrupoServico
			  ,NumDepositoInpi
FROM ods.InpiPatente) as tmp
join dw.DimPeticaoInpi as dim

CREATE TABLE #TMP_DIM_PETICAO_INPI
(
	SKPeticaoInpi INT IDENTITY NOT NULL,
	CodServico VARCHAR(20),
	DescServico VARCHAR(300),
	NumProtocolo VARCHAR(20),
	NomeCliente VARCHAR(300),
	GrupoServico VARCHAR(20),
	DataCarga DATETIME
)

INSERT INTO #TMP_DIM_PETICAO_INPI
SELECT DISTINCT CodServico
			  , DescServico
			  , NumProtocolo
			  , NomeCliente
			  , GrupoServico
			  , GETDATE() AS DataCarga
FROM #TMP_SOURCE AS ODS
WHERE NOT EXISTS (SELECT 1
				  FROM #TMP_DIM_PETICAO_INPI AS DIM
				  WHERE DIM.CodServico	 = ODS.CodServico
					AND DIM.DescServico	 = ODS.DescServico
					AND DIM.NumProtocolo = ODS.NumProtocolo
					AND DIM.NomeCliente	 = ODS.NomeCliente
					AND DIM.GrupoServico = ODS.GrupoServico)

DROP TABLE #TMP_DIM_PETICAO_INPI
DROP TABLE #TMP_SOURCE

SELECT * FROM

#TMP_DIM_PETICAO_INPI