CREATE TABLE [dbo].[ShipperPostOrderChecksum]
(
[Shipper] [int] NOT NULL,
[OrderNo] [int] NOT NULL,
[PostOrderQtyChecksum] [numeric] (20, 6) NULL,
[PostOrderDetailXML] [xml] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ShipperPo__RowCr__5EA7FE35] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NULL CONSTRAINT [DF__ShipperPo__RowCr__5F9C226E] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ShipperPo__RowMo__609046A7] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NULL CONSTRAINT [DF__ShipperPo__RowMo__61846AE0] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ShipperPostOrderChecksum] ADD CONSTRAINT [PK__ShipperP__F168284359635AD4] PRIMARY KEY CLUSTERED  ([Shipper], [OrderNo]) ON [PRIMARY]
GO
