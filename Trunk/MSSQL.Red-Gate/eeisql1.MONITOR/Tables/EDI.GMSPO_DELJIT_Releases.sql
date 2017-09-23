CREATE TABLE [EDI].[GMSPO_DELJIT_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__GMSPO_DEL__Statu__155A81E3] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__GMSPO_DELJ__Type__164EA61C] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__1742CA55] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__1836EE8E] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__192B12C7] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__1A1F3700] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[GMSPO_DELJIT_Releases] ADD CONSTRAINT [PK__GMSPO_DE__FFEE745113723971] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_GMSPO_DELJIT_Releases_2] ON [EDI].[GMSPO_DELJIT_Releases] ([RawDocumentGUID], [ShipToCode], [ShipFromCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_GMSPO_DELJIT_Releases_1] ON [EDI].[GMSPO_DELJIT_Releases] ([Status], [RawDocumentGUID], [ShipToCode], [ShipFromCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
