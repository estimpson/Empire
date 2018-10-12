CREATE TABLE [dbo].[acctg_rgni_temp]
(
[document_type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_id1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_id3] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_line] [int] NULL,
[transaction_date] [datetime] NULL,
[bill_of_lading] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [decimal] (18, 6) NULL,
[amount] [decimal] (18, 6) NULL,
[item] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_reference1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_reference2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[application] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
