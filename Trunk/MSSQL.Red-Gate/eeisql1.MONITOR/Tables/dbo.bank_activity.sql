CREATE TABLE [dbo].[bank_activity]
(
[bank_alias] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[transaction_date] [date] NOT NULL,
[transaction_type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_ref] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bank_ref] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[amount] [decimal] (18, 6) NOT NULL,
[description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reconciled] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bank_activity] ADD CONSTRAINT [ba_key] PRIMARY KEY CLUSTERED  ([bank_alias], [transaction_date], [bank_ref]) ON [PRIMARY]
GO
