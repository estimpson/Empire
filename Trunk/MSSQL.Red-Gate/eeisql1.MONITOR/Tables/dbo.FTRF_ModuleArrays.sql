CREATE TABLE [dbo].[FTRF_ModuleArrays]
(
[ID] [int] NOT NULL,
[ModuleID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArrayValues] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_ModuleArrays] ADD CONSTRAINT [PK__FTRF_ModuleArray__61F08603] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
