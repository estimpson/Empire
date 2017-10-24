CREATE TABLE [dbo].[item_preferences]
(
[item] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pricing_uom] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_analysis] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contract_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contract_account_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[costrevenue_type_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[selling_uom] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_analysis_uom] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[selling_to_price_conv] [numeric] (18, 5) NULL,
[selling_to_sa_conv] [numeric] (18, 5) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
