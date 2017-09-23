CREATE TABLE [dbo].[Part_CurrentRevLevel]
(
[BasePart] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentRevLevel] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_cum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
