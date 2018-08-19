CREATE TABLE [Notes].[Notes]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Notes__Status__79A8DF5A] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Notes__Type__7A9D0393] DEFAULT ((0)),
[Author] [int] NOT NULL,
[SubjectLine] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Body] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferencedURI] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [int] NULL,
[ImportanceFlag] [int] NULL,
[PrivacyFlag] [int] NULL,
[EntityGUID] [uniqueidentifier] NOT NULL,
[Hierarchy] [sys].[hierarchyid] NOT NULL,
[NoteGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__Notes__NoteGUID__0055DCE9] DEFAULT (newid()),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Notes__RowCreate__014A0122] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Notes__RowCreate__023E255B] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Notes__RowModifi__03324994] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Notes__RowModifi__04266DCD] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [CK__Notes__Importanc__7D79703E] CHECK (([ImportanceFlag]>=(0) AND [ImportanceFlag]<=(3)))
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [CK__Notes__PrivacyFl__7E6D9477] CHECK (([PrivacyFlag]>=(0) AND [PrivacyFlag]<=(1)))
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [PK__Notes__FFEE745198916B1D] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [UQ__Notes__A20F6C635E4EF885] UNIQUE NONCLUSTERED  ([Hierarchy]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__1451E89E] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__2DF1BF10] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__36BC0F3B] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__49EEDF40] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__7B9127CC] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__15460CD7] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__2EE5E349] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__37B03374] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__4AE30379] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__7C854C05] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__EntityGUI__7F61B8B0] FOREIGN KEY ([EntityGUID]) REFERENCES [Notes].[Entities] ([EntityGUID])
GO
