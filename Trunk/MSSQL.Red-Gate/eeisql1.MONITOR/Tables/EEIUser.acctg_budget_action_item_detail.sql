CREATE TABLE [EEIUser].[acctg_budget_action_item_detail]
(
[ACTION_ITEM_ID] [int] NOT NULL,
[ROW_ID] [int] NOT NULL,
[DESCRIPTION] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASSIGNED_TO] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MONTHLY_COST_REDUCTION] [decimal] (18, 6) NULL,
[STATUS] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_budget_action_item_detail] ADD CONSTRAINT [PK_acctg_budget_action_item_detail] PRIMARY KEY CLUSTERED  ([ACTION_ITEM_ID], [ROW_ID]) ON [PRIMARY]
GO
