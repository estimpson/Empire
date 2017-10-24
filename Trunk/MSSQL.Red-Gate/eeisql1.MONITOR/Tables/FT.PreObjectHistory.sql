CREATE TABLE [FT].[PreObjectHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CreateDT] [datetime] NOT NULL CONSTRAINT [DF__PreObject__Creat__1B102DDD] DEFAULT (getdate()),
[Serial] [int] NULL,
[WODID] [int] NOT NULL,
[Operator] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Quantity] [numeric] (20, 6) NULL,
[Status] [smallint] NULL CONSTRAINT [DF__PreObject__Statu__1C045216] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [FT].[PreObjectHistory] ADD CONSTRAINT [PK__PreObjectHistory__1927E56B] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[PreObjectHistory] ADD CONSTRAINT [UQ__PreObjectHistory__1A1C09A4] UNIQUE NONCLUSTERED  ([Serial]) ON [PRIMARY]
GO
