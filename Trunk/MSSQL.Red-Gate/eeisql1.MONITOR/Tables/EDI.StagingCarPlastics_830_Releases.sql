CREATE TABLE [EDI].[StagingCarPlastics_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingCa__Statu__2ACE98C8] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingCar__Type__2BC2BD01] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingCa__RowCr__2CB6E13A] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingCa__RowCr__2DAB0573] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingCa__RowMo__2E9F29AC] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingCa__RowMo__2F934DE5] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingCarPlastics_830_Releases] ADD CONSTRAINT [PK__StagingC__FFEE745128E65056] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
