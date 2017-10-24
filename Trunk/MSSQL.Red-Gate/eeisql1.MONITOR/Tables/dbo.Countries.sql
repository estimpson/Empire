CREATE TABLE [dbo].[Countries]
(
[CountryCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CountryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Countries] ADD CONSTRAINT [PK_CountryCodes] PRIMARY KEY CLUSTERED  ([CountryCode]) ON [PRIMARY]
GO
