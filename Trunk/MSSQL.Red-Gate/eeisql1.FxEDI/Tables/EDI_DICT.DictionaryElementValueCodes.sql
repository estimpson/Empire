CREATE TABLE [EDI_DICT].[DictionaryElementValueCodes]
(
[DictionaryVersion] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ElementCode] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValueCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictionaryRowID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_DEVC_1] ON [EDI_DICT].[DictionaryElementValueCodes] ([DictionaryVersion], [ElementCode], [ValueCode]) INCLUDE ([Description]) ON [PRIMARY]
GO
