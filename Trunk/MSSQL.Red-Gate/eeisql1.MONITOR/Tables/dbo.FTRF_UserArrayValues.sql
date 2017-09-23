CREATE TABLE [dbo].[FTRF_UserArrayValues]
(
[ID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[ArrayID] [int] NOT NULL,
[ArrayValues] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[FTRF_UserArrayValues] ADD CONSTRAINT [PK__FTRF_UserArrayVa__184C96B4] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
