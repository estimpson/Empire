CREATE TABLE [dbo].[eei_weekly_accumreceipts_fxDelete]
(
[ponumber] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [int] NOT NULL,
[AccumQty] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[eei_weekly_accumreceipts_fxDelete] ADD CONSTRAINT [PK_PurchaseOrderDetail_PurchaseOrderID_LineNumberAccum] PRIMARY KEY CLUSTERED  ([part], [ponumber], [WeekNo]) ON [PRIMARY]
GO
