CREATE TABLE [dbo].[mdata_bk]
(
[pmcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[mcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[mname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[switch] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__mdata__switch__297722B6] DEFAULT ('N'),
[display] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__mdata__display__2A6B46EF] DEFAULT ('N')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mdata_bk] ADD CONSTRAINT [PK__mdata__2882FE7D] PRIMARY KEY CLUSTERED  ([mcode]) ON [PRIMARY]
GO
