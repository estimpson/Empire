CREATE TABLE [dbo].[work_csm_program]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[base_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[oem] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[program] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vehicle] [varchar] (61) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
