CREATE TABLE [dbo].[FTRF_UserVariableValues]
(
[ID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[VariableID] [int] NOT NULL,
[VariableValue] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_UserVariableValues] ADD CONSTRAINT [PK__FTRF_UserVariabl__2F2FFC0C] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
