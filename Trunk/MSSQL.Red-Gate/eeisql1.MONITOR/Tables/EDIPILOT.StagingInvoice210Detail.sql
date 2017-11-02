CREATE TABLE [EDIPILOT].[StagingInvoice210Detail]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingIn__Statu__7159177E] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingInv__Type__724D3BB7] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[InvoiceNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[b3lXAssignedNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[n9Qualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[n9Data] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[podDate] [datetime] NULL,
[podTime] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[podName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l5LadingLineItemNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l5LadingDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[L0LadinglineItemNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l0BilledQty] [numeric] (20, 6) NULL,
[l0BilledQtyUOM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l0WeightQualfier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l0Volume] [numeric] (20, 6) NULL,
[l0VolumeUnit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l0LadingQty] [numeric] (20, 6) NULL,
[l0PackagingCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l1ladingLineItem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l1FreightRate] [numeric] (20, 6) NULL,
[l1RateQualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l1RateCharge] [numeric] (20, 6) NULL,
[L4Length] [numeric] (20, 6) NULL,
[L4Width] [numeric] (20, 6) NULL,
[L4Height] [numeric] (20, 6) NULL,
[L4UOM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[L4Qty] [numeric] (20, 6) NULL,
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowCr__73415FF0] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowCr__74358429] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowMo__7529A862] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowMo__761DCC9B] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[StagingInvoice210Detail] ADD CONSTRAINT [PK__StagingI__FFEE74506F70CF0C] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO