CREATE TABLE [EDI].[StagingDELFOR_Cumulatives_GMSPO]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingDE__Statu__742F6399] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingDEL__Type__752387D2] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyQualifier] [int] NULL,
[CumulativeQty] [int] NULL,
[CumulativeStartDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingDE__RowCr__7617AC0B] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingDE__RowCr__770BD044] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingDE__RowMo__77FFF47D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingDE__RowMo__78F418B6] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingDELFOR_Cumulatives_GMSPO] ADD CONSTRAINT [PK__StagingD__FFEE745172471B27] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
