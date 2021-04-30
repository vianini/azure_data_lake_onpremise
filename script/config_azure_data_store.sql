-- Habilita polybase
EXEC sp_configure 'polybase enabled', 1;

-- Cria o tipo conexao hadoop
EXEC sp_configure @configname = 'hadoop connectivity', @configvalue = 7;

--permite fazer insert 	
EXEC sp_configure 'allow polybase export', 1;

RECONFIGURE

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'dev@1234';

CREATE DATABASE SCOPED CREDENTIAL [AzurePolyBase]
WITH
IDENTITY = '<container_data_store>',
SECRET = '<secret>';


create EXTERNAL DATA SOURCE AzureStorageDevRaw
WITH 
(
       TYPE = HADOOP,
       LOCATION = 'wasbs://raw@<container_data_store>.blob.core.windows.net',
       CREDENTIAL = [AzurePolyBase]
);


CREATE EXTERNAL FILE FORMAT [SynapseParquetFormat] 
	WITH ( FORMAT_TYPE = PARQUET) 


CREATE EXTERNAL TABLE schema.table(
	[colum1] float,
	[colum2] datetime2(7),
	[colum3utf8] nvarchar(4000)
	)
	WITH (
	LOCATION = 'source/file/batelada_programada.parquet',
	DATA_SOURCE = [AzureStorageDevRaw],
	FILE_FORMAT = [SynapseParquetFormat]
	);
	
