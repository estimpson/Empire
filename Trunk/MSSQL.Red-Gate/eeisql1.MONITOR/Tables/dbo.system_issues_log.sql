CREATE TABLE [dbo].[system_issues_log]
(
[date] [smalldatetime] NOT NULL,
[server] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[downtime_minutes] [int] NOT NULL,
[reason_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[reason_description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[resolution_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[resolution_description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
