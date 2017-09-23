CREATE TABLE [EDI].[StagingFnG_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingFn__Statu__2D360427] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingFnG__Type__2E2A2860] DEFAULT ((0)),
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
[LastBOLReceived] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingFn__RowCr__2F1E4C99] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingFn__RowCr__301270D2] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingFn__RowMo__3106950B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingFn__RowMo__31FAB944] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingFnG_830_Releases] ADD CONSTRAINT [PK__StagingF__FFEE74512B4DBBB5] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
