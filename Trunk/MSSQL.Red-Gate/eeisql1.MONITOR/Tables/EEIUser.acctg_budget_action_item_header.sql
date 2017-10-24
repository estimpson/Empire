CREATE TABLE [EEIUser].[acctg_budget_action_item_header]
(
[ACTION_ITEM_ID] [int] NOT NULL,
[LEDGER_ACCOUNT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BUDGET_LINE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ACTION_ITEM] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DUE_DATE] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_budget_action_item_header] ADD CONSTRAINT [PK_acctg_budget_action_item_header] PRIMARY KEY CLUSTERED  ([ACTION_ITEM_ID], [LEDGER_ACCOUNT], [BUDGET_LINE]) ON [PRIMARY]
GO
