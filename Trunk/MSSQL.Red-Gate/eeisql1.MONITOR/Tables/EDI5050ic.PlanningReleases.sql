CREATE TABLE [EDI5050ic].[PlanningReleases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningR__Statu__3BEAD04E] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningRe__Type__3CDEF487] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningR__RowCr__3DD318C0] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningR__RowCr__3EC73CF9] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningR__RowMo__3FBB6132] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningR__RowMo__40AF856B] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI5050ic].[PlanningReleases] ADD CONSTRAINT [PK__Planning__FFEE74516ADAC961] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
