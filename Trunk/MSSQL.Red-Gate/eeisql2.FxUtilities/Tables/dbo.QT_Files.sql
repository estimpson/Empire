CREATE TABLE [dbo].[QT_Files] AS FILETABLE ON [PRIMARY] FILESTREAM_ON [FxUtilities_FILESTREAM]
WITH
(
	FILETABLE_DIRECTORY = N'QT_Files', FILETABLE_COLLATE_FILENAME = SQL_Latin1_General_CP1_CI_AS
)
GO
