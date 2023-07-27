if object_id('tempdb..#AuxDocumentoDeposito') is not null
    drop table #AuxDocumentoDeposito;
	
if object_id('tempdb..#TMP_SOURCE') is not null
    drop table #TMP_SOURCE;

select distinct
     dim.SKDocumento
	 ,tmp.TituloDocumento
     ,GETDATE() as DataCarga
INTO #TMP_SOURCE from (SELECT DISTINCT TituloDocumento
    FROM ods.WipoPcts) as tmp 
join dw.DimDocumento as dim
    on tmp.TituloDocumento = dim.TituloDocumento

select * from #TMP_SOURCE

CREATE TABLE #AuxDocumentoDeposito
(
    TituloDocumento VARCHAR(300) not null,
    SKDocumento int not null,
    DataCarga DATETIME NOT NULL
)

INSERT INTO #AuxDocumentoDeposito
SELECT TituloDocumento, SKDocumento, DataCarga
FROM #TMP_SOURCE AS ODS
	WHERE NOT EXISTS (
            SELECT 1 FROM #AuxDocumentoDeposito AS AUX 
                WHERE AUX.SKDocumento = ODS.SKDocumento
                    AND AUX.TituloDocumento = ODS.TituloDocumento
        )

select COUNT(*) from
#AuxDocumentoDeposito
--0
--809
if object_id('tempdb..#AuxDocumentoDeposito') is not null
    drop table #AuxDocumentoDeposito;