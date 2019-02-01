CREATE TABLE [EEIUser].[QT_MaterialRepresentativeInitials]
(
[Initials] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_Materi__Statu__50BE959B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_Materia__Type__51B2B9D4] DEFAULT ((0)),
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_Materi__RowCr__52A6DE0D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Materi__RowCr__539B0246] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_Materi__RowMo__548F267F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Materi__RowMo__55834AB8] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_MaterialRepresentativeInitials] ADD CONSTRAINT [PK__QT_Mater__FFEE74514ED64D29] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
