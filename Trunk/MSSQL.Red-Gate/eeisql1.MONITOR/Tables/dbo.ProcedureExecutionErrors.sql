CREATE TABLE [dbo].[ProcedureExecutionErrors]
(
[MessageNumber] [int] NOT NULL,
[Language] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Message] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
