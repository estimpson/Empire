CREATE TABLE [FT].[AuditRAN_order_detail]
(
[ShipperID] [int] NULL,
[AuditSource] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TranDT] [datetime] NULL,
[order_no] [numeric] (8, 0) NULL,
[destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[due_date] [datetime] NULL,
[release_no] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [numeric] (20, 6) NULL,
[std_qty] [numeric] (20, 6) NULL,
[id] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowCr__67E5C15C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowCr__68D9E595] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowMo__69CE09CE] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowMo__6AC22E07] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_order_detail] ADD CONSTRAINT [PK__AuditRAN__FFEE745165FD78EA] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
