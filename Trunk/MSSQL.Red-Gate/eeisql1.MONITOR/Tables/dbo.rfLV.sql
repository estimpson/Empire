CREATE TABLE [dbo].[rfLV]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[Wpart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wqty] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ypart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Yqty] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tstamp] [datetime] NULL CONSTRAINT [DF_rfLV_tstamp] DEFAULT (getdate())
) ON [PRIMARY]
GO
