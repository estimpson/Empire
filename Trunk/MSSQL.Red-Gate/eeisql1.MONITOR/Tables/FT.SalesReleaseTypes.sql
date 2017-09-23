CREATE TABLE [FT].[SalesReleaseTypes]
(
[ID] [tinyint] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[SalesReleaseTypes] ADD CONSTRAINT [PK__SalesReleaseType__6E17311D] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
