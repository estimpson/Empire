CREATE TABLE [dbo].[part_documentation]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentName] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpLoadDT] [datetime] NULL CONSTRAINT [DF__part_docu__UpLoa__4354584C] DEFAULT (getdate()),
[Status] [int] NOT NULL CONSTRAINT [DF__part_docu__Statu__33CEBA45] DEFAULT ((1)),
[InactiveDT_Status] [datetime] NULL,
[UploadBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InactiveBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_documentation] ADD CONSTRAINT [PK_part_documentation] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
