CREATE TABLE [EDI].[StagingNascote_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingNa__Statu__12FF9A2A] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingNas__Type__13F3BE63] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingNa__RowCr__14E7E29C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNa__RowCr__15DC06D5] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingNa__RowMo__16D02B0E] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNa__RowMo__17C44F47] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingNascote_830_Releases] ADD CONSTRAINT [PK__StagingN__FFEE7451111751B8] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
