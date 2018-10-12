CREATE TABLE [HN].[InventarioFisico]
(
[Circuito] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Estacion] [numeric] (38, 6) NOT NULL,
[Piso] [numeric] (38, 6) NOT NULL,
[Corte] [numeric] (38, 6) NOT NULL,
[Ensamble] [numeric] (38, 6) NOT NULL,
[RebajadoPiso_TransferProcesos] [numeric] (38, 6) NOT NULL,
[InventarioFisico] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Circuito] ON [HN].[InventarioFisico] ([Circuito]) ON [PRIMARY]
GO
