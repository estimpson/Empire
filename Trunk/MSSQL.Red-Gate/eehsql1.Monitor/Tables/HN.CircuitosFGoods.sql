CREATE TABLE [HN].[CircuitosFGoods]
(
[Circuito] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TotalFG] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Circuito] ON [HN].[CircuitosFGoods] ([Circuito]) ON [PRIMARY]
GO
