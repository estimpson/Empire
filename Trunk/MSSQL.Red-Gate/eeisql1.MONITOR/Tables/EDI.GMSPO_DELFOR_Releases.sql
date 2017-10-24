CREATE TABLE [EDI].[GMSPO_DELFOR_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__GMSPO_DEL__Statu__2A559EC9] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__GMSPO_DELF__Type__2B49C302] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ICCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [int] NULL,
[ReleaseDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__2C3DE73B] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__2D320B74] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__2E262FAD] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__2F1A53E6] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[GMSPO_DELFOR_Releases] ADD CONSTRAINT [PK__GMSPO_DE__FFEE7451286D5657] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_GMSPO_DELFOR_Releases_1] ON [EDI].[GMSPO_DELFOR_Releases] ([Status], [RawDocumentGUID], [ShipToCode], [ShipFromCode], [ICCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
