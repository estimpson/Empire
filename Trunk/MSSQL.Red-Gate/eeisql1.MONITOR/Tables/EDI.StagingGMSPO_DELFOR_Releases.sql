CREATE TABLE [EDI].[StagingGMSPO_DELFOR_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingGM__Statu__7D0EC25D] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingGMS__Type__7E02E696] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingGM__RowCr__7EF70ACF] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingGM__RowCr__7FEB2F08] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingGM__RowMo__00DF5341] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingGM__RowMo__01D3777A] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingGMSPO_DELFOR_Releases] ADD CONSTRAINT [PK__StagingG__FFEE74517B2679EB] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
