CREATE TABLE [dbo].[EEH_Shippers_Qty]
(
[shipper] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[qty] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EEH_Shippers_Qty_shipper] ON [dbo].[EEH_Shippers_Qty] ([shipper]) ON [PRIMARY]
GO
