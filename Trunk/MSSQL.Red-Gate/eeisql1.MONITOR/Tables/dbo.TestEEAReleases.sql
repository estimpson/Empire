CREATE TABLE [dbo].[TestEEAReleases]
(
[OrderNo] [numeric] (8, 0) NULL,
[EEHPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EEHCustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEHShipToID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderUnit] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRelease] [decimal] (38, 6) NULL,
[StdQtyRelease] [decimal] (38, 6) NULL,
[ReleaseDT] [datetime] NULL
) ON [PRIMARY]
GO
