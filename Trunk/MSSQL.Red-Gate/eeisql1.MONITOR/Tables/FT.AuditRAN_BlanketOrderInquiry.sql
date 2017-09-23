CREATE TABLE [FT].[AuditRAN_BlanketOrderInquiry]
(
[ShipperID] [int] NULL,
[AuditSource] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TranDT] [datetime] NULL,
[SalesOrderNo] [numeric] (8, 0) NULL,
[DestinationCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowCr__772804EC] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowCr__781C2925] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__AuditRAN___RowMo__79104D5E] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__AuditRAN___RowMo__7A047197] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FT].[AuditRAN_BlanketOrderInquiry] ADD CONSTRAINT [PK__AuditRAN__FFEE7451753FBC7A] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
