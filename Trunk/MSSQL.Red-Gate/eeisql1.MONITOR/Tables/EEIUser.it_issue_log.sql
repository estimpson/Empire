CREATE TABLE [EEIUser].[it_issue_log]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[datetime] [datetime] NOT NULL,
[requestor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[issue] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[response] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rootcausecategory] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[it_issue_log] ADD CONSTRAINT [PK__it_issue__3213E83F34255ADD] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
