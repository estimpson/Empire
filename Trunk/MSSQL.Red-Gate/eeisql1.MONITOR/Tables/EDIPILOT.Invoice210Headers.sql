CREATE TABLE [EDIPILOT].[Invoice210Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Invoice21__Statu__2A9194DA] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Invoice210__Type__2B85B913] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowCr__2C79DD4C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowCr__2D6E0185] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowMo__2E6225BE] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowMo__2F5649F7] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[Invoice210Headers] ADD CONSTRAINT [PK__Invoice2__FFEE7450196708D8] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
