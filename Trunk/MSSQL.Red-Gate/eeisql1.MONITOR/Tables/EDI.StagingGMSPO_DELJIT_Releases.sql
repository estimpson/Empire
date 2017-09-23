CREATE TABLE [EDI].[StagingGMSPO_DELJIT_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingGM__Statu__06982C97] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingGMS__Type__078C50D0] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingGM__RowCr__08807509] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingGM__RowCr__09749942] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingGM__RowMo__0A68BD7B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingGM__RowMo__0B5CE1B4] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingGMSPO_DELJIT_Releases] ADD CONSTRAINT [PK__StagingG__FFEE745104AFE425] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
