-- Backup NBNData..TAXON_FACT TO NBNReporting..TAXON_FACT_BACKUP

USE NBNData
GO

IF OBJECT_ID('NBNREPORTING..TAXON_FACT_BACKUP', 'U') IS NOT NULL
DROP TABLE NBNREPORTING..TAXON_FACT_BACKUP

IF OBJECT_ID('NBNREPORTING..TAXON_FACT', 'U') IS NOT NULL
DROP TABLE NBNREPORTING..TAXON_FACT

SELECT * INTO NBNREPORTING..TAXON_FACT_BACKUP
FROM TAXON_FACT

SELECT * INTO NBNREPORTING..TAXON_FACT
FROM TAXON_FACT TF
WHERE LEFT(TF.TAXON_FACT_KEY,8) = 'THU00002'
