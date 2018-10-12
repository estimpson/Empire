CREATE TABLE [dbo].[PLCounters]
(
[CurrentDT] [datetime] NOT NULL,
[object_name] [nchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[counter_name] [nchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NUMA Node] [nchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[value] [bigint] NOT NULL
) ON [PRIMARY]
GO
