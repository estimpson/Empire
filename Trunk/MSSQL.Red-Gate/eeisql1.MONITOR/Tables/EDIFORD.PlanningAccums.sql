CREATE TABLE [EDIFORD].[PlanningAccums]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningA__Statu__03F25C95] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningAc__Type__04E680CE] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningA__RowCr__05DAA507] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningA__RowCr__06CEC940] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningA__RowMo__07C2ED79] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningA__RowMo__08B711B2] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIFORD].[PlanningAccums] ADD CONSTRAINT [PK__Planning__FFEE7450020A1423] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
