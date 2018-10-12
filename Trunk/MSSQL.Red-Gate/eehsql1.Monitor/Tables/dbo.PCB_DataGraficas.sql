CREATE TABLE [dbo].[PCB_DataGraficas]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Concepto] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Valor] [decimal] (18, 4) NULL,
[DiaSemana] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Porcentaje] [decimal] (18, 4) NULL,
[Meta] [decimal] (18, 4) NULL
) ON [PRIMARY]
GO
