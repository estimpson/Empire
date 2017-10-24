CREATE TABLE [EDIPILOT].[StagingInvoice210Summary]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingIn__Statu__0A24C548] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingInv__Type__0B18E981] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowCr__0C0D0DBA] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowCr__0D0131F3] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowMo__0DF5562C] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowMo__0EE97A65] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[StagingInvoice210Summary] ADD CONSTRAINT [PK__StagingI__FFEE7450083C7CD6] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
