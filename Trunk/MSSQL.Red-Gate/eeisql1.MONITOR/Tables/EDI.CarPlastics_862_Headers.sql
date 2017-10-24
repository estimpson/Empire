CREATE TABLE [EDI].[CarPlastics_862_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__CarPlasti__Statu__7DFBF251] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CarPlastic__Type__7EF0168A] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowCr__7FE43AC3] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowCr__00D85EFC] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowMo__01CC8335] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowMo__02C0A76E] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[CarPlastics_862_Headers] ADD CONSTRAINT [PK__CarPlast__FFEE74507C13A9DF] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CarPlastics_862_Headers_1] ON [EDI].[CarPlastics_862_Headers] ([Status], [RawDocumentGUID], [DocumentDT], [DocNumber], [ControlNumber], [Release]) ON [PRIMARY]
GO
