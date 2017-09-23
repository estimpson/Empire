CREATE TABLE [EEIUser].[acctg_rgni_selected_gl_transactions]
(
[id] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[application] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_id3] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_id2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[transaction_date] [datetime] NULL,
[vendor] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_id1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[purchase_order] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[long_bill_of_lading] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bill_of_lading] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quantity] [decimal] (18, 6) NULL,
[amount] [decimal] (18, 6) NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[category] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_rgni_selected_gl_transactions] ADD CONSTRAINT [PK_acctg_rgni_selected_gl_transactions] PRIMARY KEY CLUSTERED  ([document_type], [document_id2], [vendor], [document_id1], [purchase_order], [bill_of_lading], [part]) ON [PRIMARY]
GO
