CREATE TABLE [EDI].[VisteonCzech_862_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__VisteonCz__Statu__6F03C784] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__VisteonCze__Type__6FF7EBBD] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DockCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineFeedCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReserveLineFeedCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [int] NULL,
[ReleaseDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowCr__70EC0FF6] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowCr__71E0342F] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowMo__72D45868] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowMo__73C87CA1] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[VisteonCzech_862_Releases] ADD CONSTRAINT [PK__VisteonC__FFEE74516D1B7F12] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_VisteonCzech_862_Releases_2] ON [EDI].[VisteonCzech_862_Releases] ([RawDocumentGUID], [ShipToCode], [ShipFromCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_VisteonCzech_862_Releases_1] ON [EDI].[VisteonCzech_862_Releases] ([Status], [RawDocumentGUID], [ShipToCode], [ShipFromCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
