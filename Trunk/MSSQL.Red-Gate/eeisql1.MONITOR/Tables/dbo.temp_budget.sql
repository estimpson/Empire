CREATE TABLE [dbo].[temp_budget]
(
[account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[line] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cash_flow] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[description] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[jan2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[feb2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[mar2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[apr2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[may2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[jun2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[jul2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[aug2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sep2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[oct2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[nov2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[dec2008] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[temp_budget] ADD CONSTRAINT [pk_temp_budget] PRIMARY KEY CLUSTERED  ([account], [line]) ON [PRIMARY]
GO
