CREATE TABLE [FT].[AuditRAN_releases]
(
[ShipperID] [int] NULL,
[TranDT] [datetime] NULL,
[RowID] [int] NULL,
[OrderNo] [numeric] (8, 0) NULL,
[ActiveOrderNo] [numeric] (8, 0) NULL,
[ShipTo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseDate] [datetime] NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRequired] [numeric] (20, 6) NULL,
[PriorAccum] [numeric] (20, 6) NULL,
[PostAccum] [numeric] (20, 6) NULL,
[ReleaseID] [int] NULL,
[ReleiveQty] [numeric] (20, 6) NULL,
[DeleteRelease] [bit] NULL CONSTRAINT [DF__AuditRAN___Delet__34DB1EA2] DEFAULT ((0)),
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_releases] ADD CONSTRAINT [PK__AuditRAN__3214EC2732F2D630] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
