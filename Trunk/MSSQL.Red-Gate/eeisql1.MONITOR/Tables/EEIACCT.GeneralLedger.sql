CREATE TABLE [EEIACCT].[GeneralLedger]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LedgerAccount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionDate] [datetime] NULL,
[DocumentType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentID3] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Period] [tinyint] NULL,
[Year] [smallint] NULL,
[Amount] [numeric] (20, 6) NULL,
[SourceDB] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIACCT].[GeneralLedger] ADD CONSTRAINT [PK__GeneralLedger__13841AAE] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
