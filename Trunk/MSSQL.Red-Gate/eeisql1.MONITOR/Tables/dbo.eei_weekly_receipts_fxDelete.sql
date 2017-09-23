CREATE TABLE [dbo].[eei_weekly_receipts_fxDelete]
(
[Qty] [numeric] (20, 6) NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ponumber] [int] NOT NULL,
[WeekNo] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[eei_weekly_receipts_fxDelete] ADD CONSTRAINT [PK_PurchaseOrderDetail_PurchaseOrderID_LineNumber] PRIMARY KEY CLUSTERED  ([part], [ponumber], [WeekNo]) ON [PRIMARY]
GO
