CREATE TABLE [FT].[InventoryAllocation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OnhandQty] [numeric] (20, 6) NULL,
[OrderNo] [int] NULL,
[LineID] [int] NULL,
[Sequence] [int] NULL,
[WIPQty] [numeric] (30, 12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[InventoryAllocation] ADD CONSTRAINT [PK__Inventor__3214EC2739DEC562] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_InventoryAllocation_1] ON [FT].[InventoryAllocation] ([OrderNo], [LineID], [Sequence]) ON [PRIMARY]
GO
