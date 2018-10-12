CREATE TABLE [HN].[Resumen]
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
[Dia6] [int] NULL,
[TotalFG] [numeric] (38, 6) NOT NULL,
[TotalPotting] [numeric] (38, 6) NOT NULL,
[Estacion] [numeric] (38, 6) NOT NULL,
[Piso] [numeric] (38, 6) NOT NULL,
[Corte] [numeric] (38, 6) NOT NULL,
[Ensamble] [numeric] (38, 6) NOT NULL,
[RebajadoPiso_TransferProcesos] [numeric] (38, 6) NOT NULL,
[JobCompleteProcesos] [numeric] (38, 6) NOT NULL,
[TotalInventarioFisico] [numeric] (38, 6) NULL,
[SubTotal] [numeric] (38, 6) NULL,
[Total] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
