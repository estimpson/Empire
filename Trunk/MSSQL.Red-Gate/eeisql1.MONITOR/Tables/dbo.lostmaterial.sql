CREATE TABLE [dbo].[lostmaterial]
(
[serial] [int] NOT NULL,
[part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[location] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[qty] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lostmaterial] ADD CONSTRAINT [keyerserial] PRIMARY KEY CLUSTERED  ([serial]) ON [PRIMARY]
GO
