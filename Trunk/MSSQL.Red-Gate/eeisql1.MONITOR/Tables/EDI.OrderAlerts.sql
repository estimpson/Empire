CREATE TABLE [EDI].[OrderAlerts]
(
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RawDocumentGUID] [uniqueidentifier] NOT NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReleaseNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShipToCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowCreateDT] [datetime] NOT NULL CONSTRAINT [DF__OrderAler__RowCr__3C489B24] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__OrderAler__RowCr__3D3CBF5D] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[OrderAlerts] ADD CONSTRAINT [PK__OrderAle__FFEE74503A6052B2] PRIMARY KEY NONCLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
