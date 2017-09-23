CREATE TABLE [HN].[Putaway_log]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Location] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Operator] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date] [datetime] NULL,
[DateEnd] [datetime] NULL,
[Status] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[Putaway_log] ADD CONSTRAINT [PK_Putaway_log] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
