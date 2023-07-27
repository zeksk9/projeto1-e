if object_id('tempdb..#AuxClasseNiceDeposito') is not null
    drop table #AuxClasseNiceDeposito;

if object_id('tempdb..#TMP_SOURCE') is not null
    drop table #TMP_SOURCE;


--Cria e carrega a #TMP_SOURCE
select distinct 
    SKClasseNice
    ,NumDeposito
    --,CodigoNice
    --,NaturezaMarca
    ,GETDATE() as DataCarga
INTO #TMP_SOURCE from (
SELECT DISTINCT CodigoNice as CodigoNice_ods 
				  ,NaturezaMarca as NaturezaMarca_ods
                  ,NumDepositoMadrid as NumDeposito
	FROM ods.WipoMadrid
	UNION
	SELECT DISTINCT CodigoNice as CodigoNice_ods 
				  , Natureza AS NaturezaMarca_ods
                  ,NumDepositoInpi as NumDeposito
	FROM ods.InpiMarca) as ods
join dw.DimClasseNice as dim
    on ods.CodigoNice_ods = dim.CodigoNice and ods.NaturezaMarca_ods = dim.NaturezaMarca

-- select * from #TMP_SOURCE
-- select * from #AuxClasseNiceDeposito

--Cria a aux	
CREATE TABLE #AuxClasseNiceDeposito
(
	NumDeposito VARCHAR(30),
	SKClasseNice VARCHAR(300),
	DataCarga DATETIME NOT NULL
)

--TRUNCATE TABLE #AuxClasseNiceDeposito

--INSERE OS DADOS  NA AUX DE ACORDO COM A VERIFICAÇÃO SE JÁ EXISTE NELA MESMA
INSERT INTO #AuxClasseNiceDeposito 
SELECT DISTINCT NumDeposito			   
			   ,SKClasseNice
			   ,DataCarga
FROM #TMP_SOURCE AS ODS
	WHERE NOT EXISTS (SELECT 1 FROM #AuxClasseNiceDeposito AS AUX WHERE AUX.SKClasseNice = ODS.SKClasseNice AND  ODS.NumDeposito = AUX.NumDeposito)

select count(*) from
#AuxClasseNiceDeposito
--0
--7206492

if object_id('tempdb..#AuxClasseNiceDeposito') is not null
    drop table #AuxClasseNiceDeposito;