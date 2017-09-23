CREATE TABLE [HN].[ProTrans_Shipper]
(
[HNShipperID] [int] NOT NULL,
[ProTransShipper] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Customer] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date_Stamp] [datetime] NULL
) ON [PRIMARY]
GO
