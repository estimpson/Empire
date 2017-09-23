CREATE TABLE [dbo].[ole_objects]
(
[id] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ole_object] [image] NULL,
[parent_id] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[date_stamp] [datetime] NULL,
[serial] [int] NOT NULL,
[parent_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ole_objects] ADD CONSTRAINT [PK__ole_objects__7928F116] PRIMARY KEY CLUSTERED  ([serial]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ole_objects_ui1] ON [dbo].[ole_objects] ([parent_id], [id]) ON [PRIMARY]
GO
