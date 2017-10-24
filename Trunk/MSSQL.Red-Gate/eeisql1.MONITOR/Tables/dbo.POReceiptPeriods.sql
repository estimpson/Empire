CREATE TABLE [dbo].[POReceiptPeriods]
(
[PeriodID] [int] NOT NULL,
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StdQty] [decimal] (20, 6) NOT NULL,
[AccumAdjust] [decimal] (20, 6) NOT NULL,
[LastReceivedAmount] [decimal] (20, 6) NULL,
[LastReceivedDT] [datetime] NULL,
[ReceiptCount] [int] NOT NULL
) ON [PRIMARY]
GO
