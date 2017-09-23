CREATE TABLE [EDINAL].[StagingShipSchedules]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingSh__Statu__02E2CADC] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingShi__Type__03D6EF15] DEFAULT ((0)),
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
[ScheduleType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [numeric] (20, 6) NULL,
[ReleaseDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingSh__RowCr__04CB134E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingSh__RowCr__05BF3787] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingSh__RowMo__06B35BC0] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingSh__RowMo__07A77FF9] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDINAL].[StagingShipSchedules] ADD CONSTRAINT [PK__StagingS__FFEE745115368541] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
