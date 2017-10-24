CREATE TABLE [EDI].[StagingNAL_830_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingNA__Statu__21989D9B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingNAL__Type__228CC1D4] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[DocumentImportDT] [datetime] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Release] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingNA__RowCr__2380E60D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNA__RowCr__24750A46] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingNA__RowMo__25692E7F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingNA__RowMo__265D52B8] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingNAL_830_Headers] ADD CONSTRAINT [PK__StagingN__FFEE74501FB05529] PRIMARY KEY NONCLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
