CREATE TABLE [EDI].[StagingTELEFLEX_DELFOR_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingTE__Statu__6F0C5277] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingTEL__Type__700076B0] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingTE__RowCr__70F49AE9] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTE__RowCr__71E8BF22] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingTE__RowMo__72DCE35B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTE__RowMo__73D10794] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingTELEFLEX_DELFOR_Releases] ADD CONSTRAINT [PK__StagingT__FFEE74516D240A05] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
