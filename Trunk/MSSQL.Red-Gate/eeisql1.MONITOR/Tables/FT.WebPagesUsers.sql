CREATE TABLE [FT].[WebPagesUsers]
(
[User] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PageName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultPage] [int] NULL CONSTRAINT [DF__WebPagesU__Defau__3D27DA30] DEFAULT ((0)),
[Status] [int] NULL CONSTRAINT [DF__WebPagesU__Statu__3E1BFE69] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__WebPagesU__RowCr__3F1022A2] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__WebPagesU__RowCr__400446DB] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__WebPagesU__RowMo__40F86B14] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__WebPagesU__RowMo__41EC8F4D] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[WebPagesUsers] ADD CONSTRAINT [PK__WebPages__FFEE74513B3F91BE] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
