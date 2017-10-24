CREATE TABLE [EEIUser].[acctg_budget_views]
(
[view_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[category] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sort_order] [int] NULL,
[ledger_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_budget_views] ADD CONSTRAINT [PK_acctg_budget_views] PRIMARY KEY CLUSTERED  ([view_id], [category], [ledger_account]) ON [PRIMARY]
GO
