CREATE TABLE [dbo].[FTRF_GlobalVariables]
(
[ID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VariableValue] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_GlobalVariables] ADD CONSTRAINT [PK__FTRF_GlobalVaria__324172E1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
