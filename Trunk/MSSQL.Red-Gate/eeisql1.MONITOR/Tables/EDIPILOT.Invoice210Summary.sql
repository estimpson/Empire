CREATE TABLE [EDIPILOT].[Invoice210Summary]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Invoice21__Statu__304A6E30] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Invoice210__Type__313E9269] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[b3InvoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l3Weight] [numeric] (20, 6) NULL,
[l3WeightQualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l3FreightWeight] [numeric] (20, 6) NULL,
[l3rateQualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l3Charge] [numeric] (20, 6) NULL,
[l3Advances] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l3PrepaidAmount] [numeric] (20, 6) NULL,
[l3SAC] [numeric] (20, 6) NULL,
[l3Volume] [numeric] (20, 6) NULL,
[l3VolumneQual] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[l3ladingQty] [numeric] (20, 6) NULL,
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowCr__3232B6A2] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowCr__3326DADB] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowMo__341AFF14] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowMo__350F234D] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[Invoice210Summary] ADD CONSTRAINT [PK__Invoice2__FFEE74501D3799BC] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
