CREATE TABLE [EDI].[StagingTRW_DELFOR_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingTR__Statu__35E8185D] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingTRW__Type__36DC3C96] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingTR__RowCr__37D060CF] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTR__RowCr__38C48508] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingTR__RowMo__39B8A941] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTR__RowMo__3AACCD7A] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingTRW_DELFOR_Cumulatives] ADD CONSTRAINT [PK__StagingT__FFEE745133FFCFEB] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
