CREATE TABLE [FT].[AuditRAN_shipper_detail]
(
[ShipperID] [int] NULL,
[AuditSource] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TranDT] [datetime] NULL,
[shipper] [int] NULL,
[customer_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qty_required] [numeric] (20, 6) NULL,
[qty_packed] [numeric] (20, 6) NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowCr__58A37DCC] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowCr__5997A205] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowMo__5A8BC63E] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowMo__5B7FEA77] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_shipper_detail] ADD CONSTRAINT [PK__AuditRAN__FFEE745156BB355A] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
