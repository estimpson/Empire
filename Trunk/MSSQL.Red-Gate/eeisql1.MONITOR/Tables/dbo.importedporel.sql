CREATE TABLE [dbo].[importedporel]
(
[po_number] [int] NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[due_date] [datetime] NULL,
[quantity] [numeric] (20, 6) NULL,
[week_no] [int] NULL,
[OrderNo] [int] NULL,
[EEIQty] [numeric] (20, 6) NULL,
[OperatorCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
