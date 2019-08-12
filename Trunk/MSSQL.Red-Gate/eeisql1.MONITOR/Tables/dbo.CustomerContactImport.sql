CREATE TABLE [dbo].[CustomerContactImport]
(
[Customer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Destination] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Contact] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerContactImport] ADD CONSTRAINT [PK_CustomerContactImport] PRIMARY KEY CLUSTERED  ([Destination]) ON [PRIMARY]
GO
