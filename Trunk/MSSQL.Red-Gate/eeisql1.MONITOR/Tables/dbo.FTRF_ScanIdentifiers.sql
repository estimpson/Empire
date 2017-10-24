CREATE TABLE [dbo].[FTRF_ScanIdentifiers]
(
[ID] [int] NOT NULL,
[ElementID] [int] NOT NULL,
[Identifier] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_ScanIdentifiers] ADD CONSTRAINT [PK__FTRF_ScanIdentif__79C80F94] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
