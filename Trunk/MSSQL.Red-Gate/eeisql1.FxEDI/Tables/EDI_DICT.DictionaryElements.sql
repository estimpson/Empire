CREATE TABLE [EDI_DICT].[DictionaryElements]
(
[DictionaryVersion] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ElementCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ElementName] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ElementDataType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ElementLengthMin] [int] NULL,
[ElementLengthMax] [int] NULL,
[DictionaryRowID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_DE_1] ON [EDI_DICT].[DictionaryElements] ([DictionaryVersion], [ElementCode]) INCLUDE ([ElementDataType], [ElementName]) ON [PRIMARY]
GO
