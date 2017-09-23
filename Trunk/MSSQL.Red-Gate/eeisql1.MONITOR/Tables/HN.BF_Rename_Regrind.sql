CREATE TABLE [HN].[BF_Rename_Regrind]
(
[Toppart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourcePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TargetPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[BF_Rename_Regrind] ADD CONSTRAINT [PK__BF_Renam__C57134C449D5D3C5] PRIMARY KEY CLUSTERED  ([Toppart], [SourcePart], [TargetPart]) ON [PRIMARY]
GO
GRANT SELECT ON  [HN].[BF_Rename_Regrind] TO [APPUser]
GO
