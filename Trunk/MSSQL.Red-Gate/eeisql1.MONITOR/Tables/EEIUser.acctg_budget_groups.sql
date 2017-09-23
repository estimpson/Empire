CREATE TABLE [EEIUser].[acctg_budget_groups]
(
[budget_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[authorized_user] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ledger_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[primary_manager] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[secondary_manager] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[champion] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[department] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[meeting_schedule] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[budget_control_mechanism] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[monthend_accounting_reports] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_budget_groups] ADD CONSTRAINT [PK_acctg_budget_groups] PRIMARY KEY CLUSTERED  ([budget_id], [authorized_user], [ledger_account]) ON [PRIMARY]
GO
