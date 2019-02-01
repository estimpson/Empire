CREATE TABLE [dbo].[temp_PulaskiAlert]
(
[parent_serial] [numeric] (10, 0) NULL,
[Serial] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quantity] [numeric] (20, 6) NULL,
[date_stamp] [datetime] NOT NULL,
[customer_part] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipTo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIShipToID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchedulerEmail] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[partQtyOnPallet] [numeric] (38, 6) NULL,
[partQty] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
