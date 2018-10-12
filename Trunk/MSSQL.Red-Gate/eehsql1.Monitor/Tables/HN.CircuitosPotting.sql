CREATE TABLE [HN].[CircuitosPotting]
(
[Circuito] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TotalPotting] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Circuito] ON [HN].[CircuitosPotting] ([Circuito]) ON [PRIMARY]
GO
