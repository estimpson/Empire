CREATE TABLE [dbo].[LabelDefinitions]
(
[LabelName] [sys].[sysname] NOT NULL,
[PrinterType] [sys].[sysname] NOT NULL,
[ProcedureName] [sys].[sysname] NULL,
[ProcedureArguments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LabelCode] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[LabelDefinitions] ADD CONSTRAINT [PK__LabelDefinitions__1463304E] PRIMARY KEY CLUSTERED  ([LabelName], [PrinterType]) ON [PRIMARY]
GO
