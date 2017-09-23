CREATE TABLE [dbo].[CustomerEDI_GenerationLog_bk]
(
[FileStreamID] [uniqueidentifier] NOT NULL,
[Status] [int] NOT NULL,
[Type] [int] NOT NULL,
[ShipperID] [int] NULL,
[FileGenerationDT] [datetime] NOT NULL,
[FileSendDT] [datetime] NULL,
[FileAcknowledgementDT] [datetime] NULL,
[OriginalFileName] [sys].[sysname] NULL,
[CurrentFilePath] [sys].[sysname] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL,
[RowCreateUser] [sys].[sysname] NOT NULL,
[RowModifiedDT] [datetime] NULL,
[RowModifiedUser] [sys].[sysname] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_bk] ADD CONSTRAINT [PK__Customer__FFEE74516378A19A] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_bk] ADD CONSTRAINT [UQ__Customer__2957490C66550E45] UNIQUE NONCLUSTERED  ([FileStreamID]) ON [PRIMARY]
GO
