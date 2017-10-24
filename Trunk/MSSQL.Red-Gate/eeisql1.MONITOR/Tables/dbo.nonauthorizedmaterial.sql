CREATE TABLE [dbo].[nonauthorizedmaterial]
(
[ponumber] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[datereceived] [smalldatetime] NOT NULL,
[quantity] [numeric] (20, 6) NOT NULL,
[notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendorshipper] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[nonauthorizedmaterial] ADD CONSTRAINT [PK_nonauthorizedmaterial] PRIMARY KEY CLUSTERED  ([ponumber], [vendorshipper]) ON [PRIMARY]
GO
