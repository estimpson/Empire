CREATE TABLE [dbo].[RawEDIData] AS FILETABLE ON [PRIMARY] FILESTREAM_ON [FxEDI_FILESTREAM]
WITH
(
	FILETABLE_DIRECTORY = N'RawEDIData', FILETABLE_COLLATE_FILENAME = SQL_Latin1_General_CP1_CI_AS
)
GO
