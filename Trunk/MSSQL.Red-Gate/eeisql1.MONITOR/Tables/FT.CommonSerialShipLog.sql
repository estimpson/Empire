CREATE TABLE [FT].[CommonSerialShipLog]
(
[ID] [int] NOT NULL,
[RowStatus] [int] NULL,
[Serial] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Quantity] [numeric] (20, 6) NOT NULL,
[Unit] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PackageType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserStatus] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PalletSerial] [int] NULL,
[Price] [numeric] (20, 6) NULL,
[Cost] [numeric] (20, 6) NULL,
[Weight] [numeric] (20, 6) NULL,
[TareWeight] [numeric] (20, 6) NULL,
[MfgDT] [datetime] NULL,
[ShipDT] [datetime] NULL,
[Shipper] [int] NOT NULL,
[Origin] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReceiveDT] [datetime] NULL,
[PONumber] [numeric] (8, 0) NULL,
[RcvdUnit] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RcvdPrice] [numeric] (20, 6) NULL,
[RcvdCost] [numeric] (20, 6) NULL,
[RcvdWeight] [numeric] (20, 6) NULL,
[RcvdTareWeight] [numeric] (20, 6) NULL,
[Field1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AETCNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Location] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOL] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lot] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSR_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CleanDateEEH] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[CommonSerialShipLog] ADD CONSTRAINT [PK__CommonSerialShip__5788D180] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CommonSerialShipLog_3] ON [FT].[CommonSerialShipLog] ([RowStatus], [Shipper], [ShipDT]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CommonSerialShipLog_4] ON [FT].[CommonSerialShipLog] ([Serial]) INCLUDE ([MfgDT]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CommonSerialShipLog_1] ON [FT].[CommonSerialShipLog] ([ShipDT], [Shipper]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_CommonSerialShipLog_2] ON [FT].[CommonSerialShipLog] ([Shipper], [ShipDT]) ON [PRIMARY]
GO
GRANT SELECT ON  [FT].[CommonSerialShipLog] TO [APPUser]
GO
