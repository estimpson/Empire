CREATE TABLE [FT].[ProTransASNTest]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Plant] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderNo] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderLine] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Serial] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PONumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackingSlip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Carrier] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerOrderdate] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestedShipDate] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestedShipTime] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipDate] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipTime] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WeightUOM] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrossWeight] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOLNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerFlag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NULL
) ON [PRIMARY]
GO
