CREATE TABLE [FT].[BadConsumptionKomax]
(
[PartProduced] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartConsumed] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SerialConsumed] [int] NULL,
[ConsumptionDT] [datetime] NULL,
[QtyAvailable] [numeric] (20, 6) NULL,
[QtyRequired] [numeric] (20, 6) NULL,
[QtyIssue] [numeric] (20, 6) NULL,
[QtyPrior] [numeric] (20, 6) NULL,
[QtyPost] [numeric] (20, 6) NULL,
[Discrepancy] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
