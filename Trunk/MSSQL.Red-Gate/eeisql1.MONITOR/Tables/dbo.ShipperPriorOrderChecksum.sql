CREATE TABLE [dbo].[ShipperPriorOrderChecksum]
(
[Shipper] [int] NOT NULL,
[OrderNo] [int] NOT NULL,
[PriorOrderQtyChecksum] [numeric] (20, 6) NULL,
[ShipQtyChecksum] [numeric] (20, 6) NULL,
[PriorOrderDetailXML] [xml] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ShipperPr__RowCr__5AD76D51] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NULL CONSTRAINT [DF__ShipperPr__RowCr__5BCB918A] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ShipperPr__RowMo__5CBFB5C3] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NULL CONSTRAINT [DF__ShipperPr__RowMo__5DB3D9FC] DEFAULT (suser_name()),
[Type] [int] NULL CONSTRAINT [DF__ShipperPri__Type__62788F19] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ShipperPriorOrderChecksum] ADD CONSTRAINT [PK__ShipperP__F16828435592C9F0] PRIMARY KEY CLUSTERED  ([Shipper], [OrderNo]) ON [PRIMARY]
GO
