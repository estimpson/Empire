CREATE TABLE [dbo].[venderTerms]
(
[vendor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[terms] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[venderTerms] ADD CONSTRAINT [PK_vendorTerms] PRIMARY KEY CLUSTERED  ([vendor]) ON [PRIMARY]
GO
