CREATE TABLE [EDI].[StagingCarPlastics_862_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingCa__Statu__476AD776] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingCar__Type__485EFBAF] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingCa__RowCr__49531FE8] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingCa__RowCr__4A474421] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingCa__RowMo__4B3B685A] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingCa__RowMo__4C2F8C93] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingCarPlastics_862_Headers] ADD CONSTRAINT [PK__StagingC__FFEE745045828F04] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
