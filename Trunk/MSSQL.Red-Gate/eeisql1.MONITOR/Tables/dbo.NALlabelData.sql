CREATE TABLE [dbo].[NALlabelData]
(
[Serial] [int] NULL,
[Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[BlanketPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartDescription] [varchar] (125) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyAdd1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyAdd2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyAdd3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierPrefix] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToAdd1] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToAdd2] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToAdd3] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipDate] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
