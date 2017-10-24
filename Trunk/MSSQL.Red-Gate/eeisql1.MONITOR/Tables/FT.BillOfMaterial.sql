CREATE TABLE [FT].[BillOfMaterial]
(
[ParentPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StdQty] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[BillOfMaterial] ADD CONSTRAINT [PK__BillOfMaterial__420DC656] PRIMARY KEY CLUSTERED  ([ParentPart], [ChildPart]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_BillOfMaterial_2] ON [FT].[BillOfMaterial] ([ChildPart], [ParentPart], [StdQty]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_BillOfMaterial_1] ON [FT].[BillOfMaterial] ([ParentPart], [ChildPart], [StdQty]) ON [PRIMARY]
GO
