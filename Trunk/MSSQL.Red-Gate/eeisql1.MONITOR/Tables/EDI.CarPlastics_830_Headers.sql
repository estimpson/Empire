CREATE TABLE [EDI].[CarPlastics_830_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__CarPlasti__Statu__1A9830FF] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CarPlastic__Type__1B8C5538] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowCr__1C807971] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowCr__1D749DAA] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CarPlasti__RowMo__1E68C1E3] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CarPlasti__RowMo__1F5CE61C] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[CarPlastics_830_Headers] ADD CONSTRAINT [PK__CarPlast__FFEE745018AFE88D] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CarPlastics_830_Headers_1] ON [EDI].[CarPlastics_830_Headers] ([Status], [RawDocumentGUID]) INCLUDE ([ControlNumber], [DocNumber], [DocumentDT], [DocumentImportDT]) ON [PRIMARY]
GO
