CREATE TABLE [EEIUser].[acctg_budget]
(
[budget_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ledger_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[budget_line] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cashflow] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[budget_description] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fiscal_year] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[period] [smallint] NOT NULL,
[period_amount] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_budget] ADD CONSTRAINT [PK_acctg_budget] PRIMARY KEY CLUSTERED  ([budget_id], [ledger_account], [budget_line], [fiscal_year], [period]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [budget_id] ON [EEIUser].[acctg_budget] ([budget_id], [fiscal_year]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ledger_account] ON [EEIUser].[acctg_budget] ([budget_id], [ledger_account]) ON [PRIMARY]
GO
