CREATE TABLE [HN].[Temp_purge_oldValues]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WODID] [int] NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Machine] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuantityReported] [numeric] (20, 6) NOT NULL,
[TranDT] [datetime] NOT NULL,
[QuantityApplied] [numeric] (20, 6) NOT NULL,
[Balance] [numeric] (20, 6) NOT NULL,
[jc] [numeric] (38, 8) NULL,
[Reportado] [numeric] (38, 6) NOT NULL
) ON [PRIMARY]
GO
