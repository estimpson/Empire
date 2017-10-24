CREATE TABLE [dbo].[inalfapartdestination]
(
[inapart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ourpart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[destination] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[inalfapartdestination] ADD CONSTRAINT [keyina] PRIMARY KEY CLUSTERED  ([inapart]) ON [PRIMARY]
GO
