CREATE TABLE [dbo].[FTRF_SQLArguments]
(
[ID] [int] NOT NULL,
[ElementID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Settings] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_SQLArguments] ADD CONSTRAINT [PK__FTRF_SQLArgument__6E565CE8] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
