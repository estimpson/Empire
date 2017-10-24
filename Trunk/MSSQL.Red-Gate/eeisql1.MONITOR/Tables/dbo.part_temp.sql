CREATE TABLE [dbo].[part_temp]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[frozen_price] [decimal] (20, 6) NULL,
[frozen_material_cum] [decimal] (20, 6) NULL
) ON [PRIMARY]
GO
