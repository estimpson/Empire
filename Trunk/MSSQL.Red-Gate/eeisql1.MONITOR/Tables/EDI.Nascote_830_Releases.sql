CREATE TABLE [EDI].[Nascote_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Nascote_8__Statu__43A2D185] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Nascote_83__Type__4496F5BE] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ICCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [int] NULL,
[ReleaseDT] [datetime] NULL,
[AccumReceived] [int] NULL,
[LastBOLReceived] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Nascote_8__RowCr__458B19F7] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Nascote_8__RowCr__467F3E30] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Nascote_8__RowMo__47736269] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Nascote_8__RowMo__486786A2] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[Nascote_830_Releases] ADD CONSTRAINT [PK__Nascote___FFEE745141BA8913] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
