CREATE TABLE [dbo].[FTRF_UserVariables]
(
[ID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariableValue] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_UserVariables] ADD CONSTRAINT [PK__FTRF_UserVariabl__269AB60B] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
