CREATE TABLE [dbo].[FTRF_Elements]
(
[ID] [int] NOT NULL,
[ModuleID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Settings] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_Elements] ADD CONSTRAINT [PK__FTRF_Elements__30592A6F] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
