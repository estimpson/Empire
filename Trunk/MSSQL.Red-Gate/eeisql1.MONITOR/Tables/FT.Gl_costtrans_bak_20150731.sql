CREATE TABLE [FT].[Gl_costtrans_bak_20150731]
(
[document_type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_id1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_id2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_id3] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_line] [int] NOT NULL,
[posting_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cost_account] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_amount] [decimal] (18, 6) NULL,
[ledger_amount] [decimal] (18, 6) NULL,
[document_reference1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_reference2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_remarks] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_line_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[profit_loss_posting_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[approved] [bit] NULL,
[balance_name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[period] [smallint] NULL,
[update_ledger_balances] [bit] NULL,
[debit_credit_multiplier] [smallint] NULL,
[document_transaction_id] [bigint] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
