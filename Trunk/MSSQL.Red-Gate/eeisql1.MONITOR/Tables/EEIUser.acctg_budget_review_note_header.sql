CREATE TABLE [EEIUser].[acctg_budget_review_note_header]
(
[review_note_id] [int] NOT NULL,
[fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[period] [int] NOT NULL,
[ledger_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[budget_line] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[status] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[review_note] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[response] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_budget_review_note_header] ADD CONSTRAINT [PK_acctg_budget_review_note_header] PRIMARY KEY CLUSTERED  ([review_note_id], [fiscal_year], [period], [ledger_account], [budget_line]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [acctg_budget_review_note_header_fypla] ON [EEIUser].[acctg_budget_review_note_header] ([fiscal_year], [period], [ledger_account]) ON [PRIMARY]
GO
