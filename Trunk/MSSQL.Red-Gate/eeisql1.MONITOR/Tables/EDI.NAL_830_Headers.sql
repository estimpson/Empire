CREATE TABLE [EDI].[NAL_830_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NAL_830_H__Statu__5FA0BD0C] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NAL_830_He__Type__6094E145] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NAL_830_H__RowCr__6189057E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_830_H__RowCr__627D29B7] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NAL_830_H__RowMo__63714DF0] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_830_H__RowMo__64657229] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[NAL_830_Headers] ADD CONSTRAINT [PK__NAL_830___FFEE74505DB8749A] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
