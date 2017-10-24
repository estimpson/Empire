CREATE TABLE [FT].[StatusDefn]
(
[StatusGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__StatusDef__Statu__0E01E230] DEFAULT (newid()),
[StatusTable] [sys].[sysname] NOT NULL,
[StatusColumn] [sys].[sysname] NOT NULL,
[StatusCode] [int] NOT NULL,
[StatusName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HelpText] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StatusDef__RowCr__0EF60669] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NULL CONSTRAINT [DF__StatusDef__RowCr__0FEA2AA2] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[StatusDefn] ADD CONSTRAINT [PK__StatusDe__3C1B65910C1999BE] PRIMARY KEY NONCLUSTERED  ([StatusGUID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
ALTER TABLE [FT].[StatusDefn] ADD CONSTRAINT [UQ__StatusDe__62DBBDE9093D2D13] UNIQUE CLUSTERED  ([StatusTable], [StatusColumn], [StatusCode]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
