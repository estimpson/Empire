CREATE TABLE [dbo].[FTRF_ServerDSN]
(
[ID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_ServerDSN] ADD CONSTRAINT [PK__FTRF_ServerDSN__66B53B20] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
