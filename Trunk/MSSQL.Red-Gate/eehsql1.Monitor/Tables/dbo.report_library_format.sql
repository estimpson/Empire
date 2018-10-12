CREATE TABLE [dbo].[report_library_format]
(
[name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FormatLabel] [nvarchar] (3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[report_library_format] ADD CONSTRAINT [PK_report_library_format] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
