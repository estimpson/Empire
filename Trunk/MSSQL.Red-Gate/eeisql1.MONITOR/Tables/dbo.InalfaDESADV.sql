CREATE TABLE [dbo].[InalfaDESADV]
(
[ShipperID] [int] NOT NULL,
[TradingPartner] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ASNDate] [datetime] NOT NULL,
[ShippedDate] [datetime] NOT NULL,
[ArrivalDate] [datetime] NOT NULL,
[TotalLadingQty] [int] NOT NULL,
[GrossWeight] [int] NOT NULL,
[ProNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaterialIssuerID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SupplierID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShipToID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Dock] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransMode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SCAC] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AETCReason] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AETCNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrailerNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SealNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineItemID] [int] NOT NULL,
[PartBoxCount] [int] NOT NULL,
[StdPack] [int] NOT NULL,
[PCINumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PalletLicense] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QtyShipped] [int] NOT NULL,
[CustomerPO] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[POLine] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LicensePlate] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LicensePlateQty] [int] NOT NULL,
[PartOriginal] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentSerial] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO