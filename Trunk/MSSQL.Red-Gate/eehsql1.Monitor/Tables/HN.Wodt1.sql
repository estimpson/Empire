CREATE TABLE [HN].[Wodt1]
(
[ID] [int] NOT NULL,
[CreateDT] [datetime] NULL,
[Status] [smallint] NOT NULL,
[Machine] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Tool] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [smallint] NOT NULL,
[Sequence] [int] NULL,
[SetupHours] [numeric] (20, 6) NOT NULL,
[StartDT] [datetime] NULL,
[EndDT] [datetime] NULL
) ON [PRIMARY]
GO
