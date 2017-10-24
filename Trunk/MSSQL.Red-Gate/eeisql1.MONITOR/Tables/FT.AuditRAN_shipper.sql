CREATE TABLE [FT].[AuditRAN_shipper]
(
[ShipperID] [int] NULL,
[AuditSource] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TranDT] [datetime] NULL,
[id] [int] NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowCr__51025C04] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowCr__51F6803D] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowMo__52EAA476] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowMo__53DEC8AF] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_shipper] ADD CONSTRAINT [PK__AuditRAN__FFEE74514F1A1392] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
