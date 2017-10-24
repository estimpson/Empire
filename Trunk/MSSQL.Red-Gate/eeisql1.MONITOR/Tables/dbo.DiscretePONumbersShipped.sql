CREATE TABLE [dbo].[DiscretePONumbersShipped]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OrderNo] [int] NULL,
[ShipDate] [datetime] NULL,
[Qty] [numeric] (20, 6) NULL,
[DiscretePONumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Shipper] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DiscretePONumbersShipped] ADD CONSTRAINT [PK__Discrete__3214EC27117F9965] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
