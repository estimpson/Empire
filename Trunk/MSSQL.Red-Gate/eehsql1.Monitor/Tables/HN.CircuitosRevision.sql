CREATE TABLE [HN].[CircuitosRevision]
(
[Circuito] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ubicacion] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Revision] [int] NULL,
[cost] [numeric] (20, 6) NULL,
[CantidadCircuito] [int] NOT NULL,
[Dia1] [int] NULL,
[Dia2] [int] NULL,
[Dia3] [int] NULL,
[Dia4] [int] NULL,
[Dia5] [int] NULL,
[Dia6] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Circuito] ON [HN].[CircuitosRevision] ([Circuito]) ON [PRIMARY]
GO
