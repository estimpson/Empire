CREATE TABLE [dbo].[FTRF_SQLResultSets]
(
[ID] [int] NOT NULL,
[ElementID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Settings] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_SQLResultSets] ADD CONSTRAINT [PK__FTRF_SQLResultSe__77DFC722] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
