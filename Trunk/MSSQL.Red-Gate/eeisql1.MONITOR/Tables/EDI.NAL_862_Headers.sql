CREATE TABLE [EDI].[NAL_862_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NAL_862_H__Statu__519CB678] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NAL_862_He__Type__5290DAB1] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NAL_862_H__RowCr__5384FEEA] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_862_H__RowCr__54792323] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NAL_862_H__RowMo__556D475C] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_862_H__RowMo__56616B95] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[NAL_862_Headers] ADD CONSTRAINT [PK__NAL_862___FFEE74504FB46E06] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_NAL_862_Headers_1] ON [EDI].[NAL_862_Headers] ([Status], [RawDocumentGUID], [DocumentDT], [DocNumber], [ControlNumber], [Release]) ON [PRIMARY]
GO
