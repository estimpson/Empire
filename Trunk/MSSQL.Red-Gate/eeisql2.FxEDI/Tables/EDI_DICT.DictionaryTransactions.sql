CREATE TABLE [EDI_DICT].[DictionaryTransactions]
(
[DictionaryVersion] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictionaryRowID] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EDI_DICT].[DictionaryTransactions] ADD CONSTRAINT [PK__Dictiona__FFEE7451F1D67C0B] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
