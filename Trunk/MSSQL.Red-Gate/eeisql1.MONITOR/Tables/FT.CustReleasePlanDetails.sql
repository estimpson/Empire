CREATE TABLE [FT].[CustReleasePlanDetails]
(
[RPDID] [int] NOT NULL IDENTITY(1, 1),
[RPID] [int] NOT NULL,
[ShipTo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerPO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelYear] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesOrderNo] [int] NULL,
[LastShipper] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastShipDate] [datetime] NULL,
[LastShippedAccum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlanDetails] ADD CONSTRAINT [PK_CustReleasePlanDetails] PRIMARY KEY CLUSTERED  ([RPDID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[CustReleasePlanDetails] ADD CONSTRAINT [FK_CustReleasePlanDetails_CustReleasePlans] FOREIGN KEY ([RPID]) REFERENCES [FT].[CustReleasePlans] ([RPID])
GO
