CREATE TABLE [EDI].[StagingFnG_830_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingFn__Statu__15E55D1F] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingFnG__Type__16D98158] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyQualifier] [int] NULL,
[CumulativeQty] [int] NULL,
[CumulativeStartDT] [datetime] NULL,
[CumulativeEndDT] [datetime] NULL,
[LastReceivedQty] [int] NULL,
[LastReceivedDT] [datetime] NULL,
[LastReceivedBOL] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingFn__RowCr__17CDA591] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingFn__RowCr__18C1C9CA] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingFn__RowMo__19B5EE03] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingFn__RowMo__1AAA123C] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingFnG_830_Cumulatives] ADD CONSTRAINT [PK__StagingF__FFEE745113FD14AD] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
