CREATE TABLE [dbo].[part_customer_copy]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[customer_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[customer_standard_pack] [numeric] (20, 6) NULL,
[taxable] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_unit] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upc_code] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[blanket_price] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
