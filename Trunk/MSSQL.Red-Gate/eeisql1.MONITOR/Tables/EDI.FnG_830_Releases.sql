CREATE TABLE [EDI].[FnG_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__FnG_830_R__Statu__36BF6E61] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__FnG_830_Re__Type__37B3929A] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ICCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [int] NULL,
[AccumReceived] [int] NULL,
[LastBOLReceived] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__FnG_830_R__RowCr__38A7B6D3] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__FnG_830_R__RowCr__399BDB0C] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__FnG_830_R__RowMo__3A8FFF45] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__FnG_830_R__RowMo__3B84237E] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[FnG_830_Releases] ADD CONSTRAINT [PK__FnG_830___FFEE745134D725EF] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
