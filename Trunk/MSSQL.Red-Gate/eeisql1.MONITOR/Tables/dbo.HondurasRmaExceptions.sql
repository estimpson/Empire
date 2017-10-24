CREATE TABLE [dbo].[HondurasRmaExceptions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OperatorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionDate] [datetime] NULL,
[Exception] [varchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HondurasRmaExceptions] ADD CONSTRAINT [PK__Honduras__3214EC273E5F8AAA] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
