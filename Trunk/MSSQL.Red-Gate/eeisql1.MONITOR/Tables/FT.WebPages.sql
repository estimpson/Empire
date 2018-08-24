CREATE TABLE [FT].[WebPages]
(
[PageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FilePath] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PageGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NULL CONSTRAINT [DF__WebPages__Status__3492942F] DEFAULT ((0)),
[ParentID] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__WebPages__RowCre__3586B868] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__WebPages__RowCre__367ADCA1] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__WebPages__RowMod__376F00DA] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__WebPages__RowMod__38632513] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[WebPages] ADD CONSTRAINT [PK__WebPages__FFEE745132AA4BBD] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[WebPages] ADD CONSTRAINT [UQ__WebPages__4EE90DE945BD2031] UNIQUE NONCLUSTERED  ([PageName]) ON [PRIMARY]
GO
