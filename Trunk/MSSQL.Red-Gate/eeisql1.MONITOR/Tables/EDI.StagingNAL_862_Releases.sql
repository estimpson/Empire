CREATE TABLE [EDI].[StagingNAL_862_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingNA__Statu__3E34DC49] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingNAL__Type__3F290082] DEFAULT ((0)),
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
[LastBOLReceived] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingNA__RowCr__401D24BB] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNA__RowCr__411148F4] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingNA__RowMo__42056D2D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNA__RowMo__42F99166] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingNAL_862_Releases] ADD CONSTRAINT [PK__StagingN__FFEE74513C4C93D7] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
