CREATE TABLE [EDI].[CarPlastics_862_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__CarPlasti__Statu__07855C8B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CarPlastic__Type__087980C4] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowCr__096DA4FD] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowCr__0A61C936] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowMo__0B55ED6F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowMo__0C4A11A8] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[CarPlastics_862_Releases] ADD CONSTRAINT [PK__CarPlast__FFEE7451059D1419] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CarPlastics_862_Releases_2] ON [EDI].[CarPlastics_862_Releases] ([RawDocumentGUID], [ShipToCode], [ShipFromCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CarPlastics_862_Releases_1] ON [EDI].[CarPlastics_862_Releases] ([Status], [RawDocumentGUID], [ShipToCode], [ShipFromCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
