CREATE TABLE [FT].[Users]
(
[UserID] [uniqueidentifier] NULL CONSTRAINT [DF__Users__UserID__14E31E92] DEFAULT (newid()),
[Status] [int] NOT NULL CONSTRAINT [DF__Users__Status__15D742CB] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Users__Type__16CB6704] DEFAULT ((0)),
[OperatorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginName] [sys].[sysname] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Users__RowCreate__18B3AF76] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Users__RowCreate__19A7D3AF] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Users__RowModifi__1A9BF7E8] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Users__RowModifi__1B901C21] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[Users] ADD CONSTRAINT [PK__Users__FFEE74510D41FCCA] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[Users] ADD CONSTRAINT [UQ__Users__71C88268101E6975] UNIQUE NONCLUSTERED  ([OperatorCode], [LoginName]) ON [PRIMARY]
GO
ALTER TABLE [FT].[Users] ADD CONSTRAINT [UQ__Users__1788CCAD12FAD620] UNIQUE NONCLUSTERED  ([UserID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[Users] ADD CONSTRAINT [FK__Users__OperatorC__17BF8B3D] FOREIGN KEY ([OperatorCode]) REFERENCES [dbo].[employee] ([operator_code])
GO
