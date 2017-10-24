CREATE TABLE [EDI].[FnG_830_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__FnG_830_H__Statu__4048D89B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__FnG_830_He__Type__413CFCD4] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__FnG_830_H__RowCr__4231210D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__FnG_830_H__RowCr__43254546] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__FnG_830_H__RowMo__4419697F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__FnG_830_H__RowMo__450D8DB8] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[FnG_830_Headers] ADD CONSTRAINT [PK__FnG_830___FFEE74503E609029] PRIMARY KEY NONCLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
