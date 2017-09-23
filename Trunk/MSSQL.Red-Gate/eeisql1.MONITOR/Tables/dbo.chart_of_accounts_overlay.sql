CREATE TABLE [dbo].[chart_of_accounts_overlay]
(
[fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[coa] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[account] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[account_description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[coa_level_1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[coa_level_2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
