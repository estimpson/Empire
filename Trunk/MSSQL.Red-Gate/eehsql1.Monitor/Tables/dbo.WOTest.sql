CREATE TABLE [dbo].[WOTest]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[WOID] [int] NOT NULL,
[CreateDT] [datetime] NULL,
[TopPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [smallint] NOT NULL,
[Sequence] [int] NULL,
[DueDT] [datetime] NULL,
[QtyRequired] [numeric] (20, 6) NOT NULL,
[QtyLabelled] [numeric] (20, 6) NOT NULL,
[QtyCompleted] [numeric] (20, 6) NOT NULL,
[QtyDefect] [numeric] (20, 6) NOT NULL,
[QtyRework] [numeric] (20, 6) NOT NULL,
[SetupHours] [numeric] (20, 6) NOT NULL,
[StartDT] [datetime] NULL,
[EndDT] [datetime] NULL,
[SourceType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartNOOK] [bit] NULL,
[CommentsOnHold] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StdPack] [numeric] (20, 6) NULL,
[BIN] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
