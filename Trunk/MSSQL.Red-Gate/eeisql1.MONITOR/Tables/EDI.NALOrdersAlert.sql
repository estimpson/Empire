CREATE TABLE [EDI].[NALOrdersAlert]
(
[RowID] [int] NOT NULL IDENTITY(1, 1),
[DateInserted] [datetime] NULL CONSTRAINT [DF__NALOrders__DateI__14BCFA13] DEFAULT (getdate()),
[ReleaseNo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
