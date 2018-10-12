CREATE TABLE [dbo].[BackflushReview]
(
[WODID] [int] NULL,
[PartProduced] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SerialProduced] [int] NULL,
[QtyProduced] [numeric] (20, 6) NULL,
[BOMID] [int] NULL,
[PartConsumed] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SerialConsumed] [int] NULL,
[QtyAvailable] [numeric] (20, 6) NULL,
[QtyRequired] [numeric] (20, 6) NULL,
[QtyIssue] [numeric] (20, 6) NULL,
[QtyOverage] [numeric] (20, 6) NULL,
[JCDT] [datetime] NULL,
[UndoDT] [datetime] NULL,
[Issued] [numeric] (20, 6) NULL,
[UndoIssued] [numeric] (20, 6) NULL,
[Excess] [numeric] (20, 6) NULL,
[UndoExcess] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
