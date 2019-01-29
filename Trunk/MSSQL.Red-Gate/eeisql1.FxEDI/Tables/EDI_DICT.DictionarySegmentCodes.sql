CREATE TABLE [EDI_DICT].[DictionarySegmentCodes]
(
[DictionaryVersion] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictionaryRowID] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EDI_DICT].[DictionarySegmentCodes] ADD CONSTRAINT [PK__Dictiona__FFEE7451CF1851A9] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
