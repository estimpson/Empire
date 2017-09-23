CREATE TABLE [EDI].[StagingVisteonCzech_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingVi__Statu__5BF0F310] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingVis__Type__5CE51749] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingVi__RowCr__5DD93B82] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingVi__RowCr__5ECD5FBB] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingVi__RowMo__5FC183F4] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingVi__RowMo__60B5A82D] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingVisteonCzech_830_Releases] ADD CONSTRAINT [PK__StagingV__FFEE74515A08AA9E] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
