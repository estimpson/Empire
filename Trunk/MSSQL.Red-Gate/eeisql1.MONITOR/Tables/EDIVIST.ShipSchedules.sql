CREATE TABLE [EDIVIST].[ShipSchedules]
(
[Status] [int] NOT NULL CONSTRAINT [DF__ShipSched__Statu__4297387F] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__ShipSchedu__Type__438B5CB8] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ShipSched__RowCr__447F80F1] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ShipSched__RowCr__4573A52A] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ShipSched__RowMo__4667C963] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ShipSched__RowMo__475BED9C] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIVIST].[ShipSchedules] ADD CONSTRAINT [PK__ShipSche__FFEE745140AEF00D] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
