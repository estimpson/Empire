CREATE TABLE [EDI].[StagingTRW_DELJIT_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingTR__Statu__14AEDFBF] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingTRW__Type__15A303F8] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingTR__RowCr__16972831] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTR__RowCr__178B4C6A] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingTR__RowMo__187F70A3] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTR__RowMo__197394DC] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingTRW_DELJIT_Releases] ADD CONSTRAINT [PK__StagingT__FFEE745112C6974D] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
