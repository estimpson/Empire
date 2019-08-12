CREATE TABLE [EDIEDIFACT96A].[StagingPlanningAuthAccums]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingPl__Statu__5C11AD6B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingPla__Type__5D05D1A4] DEFAULT ((0)),
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
[RAWCUMStartDT] [datetime] NULL,
[RAWCUMEndDT] [datetime] NULL,
[RAWCUM] [int] NULL,
[FABCUMStartDT] [datetime] NULL,
[FABCUMEndDT] [datetime] NULL,
[FABCUM] [int] NULL,
[PriorCUMStartDT] [datetime] NULL,
[PriorCUMEndDT] [datetime] NULL,
[PriorCUM] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingPl__RowCr__5DF9F5DD] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingPl__RowCr__5EEE1A16] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingPl__RowMo__5FE23E4F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingPl__RowMo__60D66288] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIEDIFACT96A].[StagingPlanningAuthAccums] ADD CONSTRAINT [PK__StagingP__FFEE7450F2292330] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
