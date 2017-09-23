CREATE TABLE [FT].[AuditRAN_requirements]
(
[ShipperID] [int] NULL,
[TranDT] [datetime] NULL,
[RowID] [int] NULL,
[ActiveOrderNo] [numeric] (8, 0) NULL,
[ShipTo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseDate] [datetime] NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRequired] [numeric] (20, 6) NULL,
[PriorAccum] [numeric] (20, 6) NULL,
[PostAccum] [numeric] (20, 6) NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_requirements] ADD CONSTRAINT [PK__AuditRAN__3214EC272B51B468] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
