CREATE TABLE [EDI].[StagingVisteonCzech_830_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingVi__Statu__657A5D4A] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingVis__Type__666E8183] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingVi__RowCr__6762A5BC] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingVi__RowCr__6856C9F5] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingVi__RowMo__694AEE2E] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingVi__RowMo__6A3F1267] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingVisteonCzech_830_Headers] ADD CONSTRAINT [PK__StagingV__FFEE7450639214D8] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
