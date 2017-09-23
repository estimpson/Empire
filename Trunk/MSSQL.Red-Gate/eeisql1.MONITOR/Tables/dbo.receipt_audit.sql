CREATE TABLE [dbo].[receipt_audit]
(
[po_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [numeric] (20, 6) NULL,
[last_received_dt] [datetime] NULL
) ON [PRIMARY]
GO
