CREATE TABLE [EDI].[VisteonCzech_862_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__VisteonCz__Statu__788D31BE] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__VisteonCze__Type__798155F7] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowCr__7A757A30] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowCr__7B699E69] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowMo__7C5DC2A2] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowMo__7D51E6DB] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[VisteonCzech_862_Headers] ADD CONSTRAINT [PK__VisteonC__FFEE745076A4E94C] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_VisteonCzech_862_Headers_1] ON [EDI].[VisteonCzech_862_Headers] ([Status], [RawDocumentGUID], [DocumentDT], [DocNumber], [ControlNumber], [Release]) ON [PRIMARY]
GO
