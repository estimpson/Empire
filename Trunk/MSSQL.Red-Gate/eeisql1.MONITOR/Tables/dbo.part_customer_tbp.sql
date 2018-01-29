CREATE TABLE [dbo].[part_customer_tbp]
(
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[customer_part_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[effect_date] [datetime] NOT NULL,
[price] [numeric] (20, 6) NULL,
[quote_number] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
