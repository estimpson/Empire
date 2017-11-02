CREATE TABLE [EDI].[EDIDocuments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__EDIDocumen__GUID__531856C7] DEFAULT (newid()),
[Status] [int] NOT NULL CONSTRAINT [DF__EDIDocume__Statu__540C7B00] DEFAULT ((0)),
[FileName] [sys].[sysname] NOT NULL,
[HeaderData] [xml] NULL,
[RowTS] [timestamp] NOT NULL,
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__EDIDocume__RowCr__55009F39] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__EDIDocume__RowCr__55F4C372] DEFAULT (suser_name()),
[Data] [xml] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIStandard] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Release] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliverySchedule] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageNumber] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MoparSSDDocument] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionEDIFACTorX12] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EDI].[EDIDocuments] ADD CONSTRAINT [PK__EDIDocum__3214EC275F579441] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_EDIDocuments_rfl] ON [EDI].[EDIDocuments] ([RowCreateDT], [Status], [FileName]) INCLUDE ([GUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_EDIDocuments_1] ON [EDI].[EDIDocuments] ([RowCreateDT], [Type]) ON [PRIMARY]
GO
