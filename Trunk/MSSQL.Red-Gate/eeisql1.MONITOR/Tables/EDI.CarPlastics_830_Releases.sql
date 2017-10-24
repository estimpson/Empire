CREATE TABLE [EDI].[CarPlastics_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__CarPlasti__Statu__110EC6C5] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CarPlastic__Type__1202EAFE] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowCr__12F70F37] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowCr__13EB3370] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowMo__14DF57A9] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowMo__15D37BE2] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[CarPlastics_830_Releases] ADD CONSTRAINT [PK__CarPlast__FFEE74510F267E53] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CarPlastics_830_Releases_1] ON [EDI].[CarPlastics_830_Releases] ([Status], [RawDocumentGUID], [ShipToCode], [ShipFromCode], [ICCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
