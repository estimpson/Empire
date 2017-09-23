CREATE TABLE [dbo].[pbcatedt]
(
[pbe_name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[pbe_edit] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pbe_type] [smallint] NULL,
[pbe_cntr] [int] NULL,
[pbe_seqn] [smallint] NOT NULL,
[pbe_flag] [int] NULL,
[pbe_work] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
