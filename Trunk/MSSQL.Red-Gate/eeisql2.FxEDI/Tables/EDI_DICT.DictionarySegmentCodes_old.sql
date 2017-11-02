CREATE TABLE [EDI_DICT].[DictionarySegmentCodes_old]
(
[DictionaryVersion] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictionaryRowID] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [EDI_DICT].[DictionarySegmentCodes_old] ADD CONSTRAINT [PK__Dictiona__FFEE745162219492] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_DSC_1] ON [EDI_DICT].[DictionarySegmentCodes_old] ([DictionaryVersion], [Code]) INCLUDE ([Description]) ON [PRIMARY]
GO
GRANT SELECT ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\ABoulanger]
GO
GRANT DELETE ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT INSERT ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT SELECT ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT ALTER ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT CONTROL ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT REFERENCES ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT TAKE OWNERSHIP ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT UPDATE ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT VIEW CHANGE TRACKING ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT VIEW DEFINITION ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [EMPIREELECT\CDiPaola]
GO
GRANT SELECT ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [guest]
GO
GRANT SELECT ON  [EDI_DICT].[DictionarySegmentCodes_old] TO [public]
GO
