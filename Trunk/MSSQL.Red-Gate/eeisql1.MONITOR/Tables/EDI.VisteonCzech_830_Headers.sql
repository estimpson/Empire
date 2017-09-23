CREATE TABLE [EDI].[VisteonCzech_830_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__VisteonCz__Statu__0BA00632] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__VisteonCze__Type__0C942A6B] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowCr__0D884EA4] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowCr__0E7C72DD] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowMo__0F709716] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowMo__1064BB4F] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[VisteonCzech_830_Headers] ADD CONSTRAINT [PK__VisteonC__FFEE745009B7BDC0] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_VisteonCzech_830_Headers_1] ON [EDI].[VisteonCzech_830_Headers] ([Status], [RawDocumentGUID]) INCLUDE ([ControlNumber], [DocNumber], [DocumentDT], [DocumentImportDT]) ON [PRIMARY]
GO
