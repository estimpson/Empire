CREATE TABLE [dbo].[GMSPOExceptionsBlanketPartPrice]
(
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlertType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReleaseNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsigneeCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerModelYear] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MaxPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaxPrice] [decimal] (20, 6) NULL,
[MinPrice] [decimal] (20, 6) NULL
) ON [PRIMARY]
GO
