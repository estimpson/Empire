CREATE TABLE [FT].[AuditRAN_order_header]
(
[ShipperID] [int] NULL,
[AuditSource] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TranDT] [datetime] NULL,
[order_no] [numeric] (8, 0) NULL,
[our_cum] [numeric] (20, 6) NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowCr__60449F94] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowCr__6138C3CD] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowMo__622CE806] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowMo__63210C3F] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_order_header] ADD CONSTRAINT [PK__AuditRAN__FFEE74515E5C5722] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
