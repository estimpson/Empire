CREATE TABLE [dbo].[FTRF_ModuleVariables]
(
[ID] [int] NOT NULL,
[ModuleID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariableValue] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_ModuleVariables] ADD CONSTRAINT [PK__FTRF_ModuleVaria__4E1E9780] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
