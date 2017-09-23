CREATE TABLE [EEIUser].[QT_LightingStudy_FunctionCodes]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FunctionCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_LightingStudy_FunctionCodes] ADD CONSTRAINT [PK__QT_Light__3214EC2711282D76] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
