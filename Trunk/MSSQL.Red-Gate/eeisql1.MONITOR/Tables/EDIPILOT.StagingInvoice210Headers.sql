CREATE TABLE [EDIPILOT].[StagingInvoice210Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingIn__Statu__23257D3C] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingInv__Type__2419A175] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[b3ShipmentQualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3InvoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3ShipperID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3MethodOfPayment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3WeightUnit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3InvoiceDate] [datetime] NULL,
[b3NetAmoutDue] [numeric] (20, 6) NULL,
[b3CorrectionIndicator] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3DeliveryDate] [datetime] NULL,
[b3DateTimeQualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3SCAC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[c3Currency] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3SCAC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3RoutingSequence] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3TransMode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3StdPointLocationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3InvoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3InvoiceDate] [datetime] NULL,
[r3InvoiceAmount] [numeric] (20, 6) NULL,
[r3Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[r3ServiceLevelCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowCr__250DC5AE] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowCr__2601E9E7] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowMo__26F60E20] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowMo__27EA3259] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[StagingInvoice210Headers] ADD CONSTRAINT [PK__StagingI__FFEE7450213D34CA] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
