CREATE TABLE [dbo].[sqlanysystrigger]
(
[trigger_id] [smallint] NOT NULL,
[table_id] [smallint] NOT NULL,
[event] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trigger_time] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trigger_order] [smallint] NULL,
[foreign_table_id] [smallint] NULL,
[foreign_key_id] [smallint] NULL,
[referential_action] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[trigger_name] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[trigger_defn] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[remarks] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
