CREATE TABLE [dbo].[report_library]
(
[name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[report] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[object_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[library_name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[preview] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[print_setup] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[printer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[copies] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[report_library] ADD CONSTRAINT [PK__report_library__168449D3] PRIMARY KEY CLUSTERED  ([name], [report]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[report_library] ADD CONSTRAINT [FK__report_li__repor__7760A435] FOREIGN KEY ([report]) REFERENCES [dbo].[report_list] ([report])
GO
ALTER TABLE [dbo].[report_library] ADD CONSTRAINT [FK__report_li__repor__766C7FFC] FOREIGN KEY ([report]) REFERENCES [dbo].[report_list] ([report])
GO
GRANT SELECT ON  [dbo].[report_library] TO [APPUser]
GO
