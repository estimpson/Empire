CREATE TABLE [EDIYazaki].[StagingPlanningAccums]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingPl__Statu__208B0A53] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingPla__Type__217F2E8C] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ReleaseNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsigneeCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPOLine] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerModelYear] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerECL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastQtyReceived] [numeric] (20, 6) NULL,
[LastQtyDT] [datetime] NULL,
[LastShipper] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastAccumQty] [numeric] (20, 6) NULL,
[LastAccumDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingPl__RowCr__227352C5] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingPl__RowCr__236776FE] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingPl__RowMo__245B9B37] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingPl__RowMo__254FBF70] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIYazaki].[StagingPlanningAccums] ADD CONSTRAINT [PK__StagingP__FFEE745042210848] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
