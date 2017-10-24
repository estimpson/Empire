CREATE TABLE [dbo].[sqlAnysysindexes]
(
[icreator] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[iname] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[fname] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creator] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tname] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[indextype] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[colnames] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[interval] [smallint] NOT NULL,
[level_num] [smallint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
