CREATE TABLE [EDI].[StagingNascote_830_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingNa__Statu__270692D7] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingNas__Type__27FAB710] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingNa__RowCr__28EEDB49] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNa__RowCr__29E2FF82] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingNa__RowMo__2AD723BB] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNa__RowMo__2BCB47F4] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingNascote_830_Cumulatives] ADD CONSTRAINT [PK__StagingN__FFEE7451251E4A65] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
