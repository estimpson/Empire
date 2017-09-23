CREATE TABLE [dbo].[dup_gl]
(
[Serial] [int] NOT NULL,
[date_stamp] [datetime] NOT NULL,
[type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_line] [int] NULL,
[Account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[good_bad] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dup_gl] ADD CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED  ([Serial], [date_stamp]) ON [PRIMARY]
GO
