CREATE TABLE [dbo].[commodity_prices]
(
[date] [datetime] NOT NULL,
[exchange] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[commodity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[contract] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [decimal] (18, 10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[commodity_prices] ADD CONSTRAINT [PK_commodity_prices] PRIMARY KEY CLUSTERED  ([date], [exchange], [commodity], [contract]) ON [PRIMARY]
GO
