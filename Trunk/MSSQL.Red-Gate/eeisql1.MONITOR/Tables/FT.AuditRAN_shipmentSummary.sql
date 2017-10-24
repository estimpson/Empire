CREATE TABLE [FT].[AuditRAN_shipmentSummary]
(
[ShipperID] [int] NULL,
[TranDT] [datetime] NULL,
[ShipTo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyPacked] [numeric] (20, 6) NULL,
[ActiveOrderNo] [numeric] (8, 0) NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_shipmentSummary] ADD CONSTRAINT [PK__AuditRAN__3214EC2727812384] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
