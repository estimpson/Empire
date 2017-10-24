CREATE TABLE [FT].[ShipLog_bkup]
(
[RowStatus] [int] NULL CONSTRAINT [DF__ShipLog__RowStat__479C827A] DEFAULT ((100)),
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
[RcvdTareWeight] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[ShipLog_bkup] ADD CONSTRAINT [PK__ShipLog__46A85E41] PRIMARY KEY NONCLUSTERED  ([Serial], [Shipper]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ShipLog_1] ON [FT].[ShipLog_bkup] ([Part], [ShipDT], [Quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ShipLog_2] ON [FT].[ShipLog_bkup] ([ShipDT], [Shipper]) ON [PRIMARY]
GO
