CREATE TABLE [EDI].[XMLShipNotice_ASNExceptionHandler]
(
[ASNOverlayGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BillTo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipTo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__XMLShipNo__Statu__511B90EB] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__XMLShipNot__Type__520FB524] DEFAULT ((0)),
[ExceptionHandler] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__XMLShipNo__RowCr__5303D95D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__XMLShipNo__RowCr__53F7FD96] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__XMLShipNo__RowMo__54EC21CF] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__XMLShipNo__RowMo__55E04608] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[XMLShipNotice_ASNExceptionHandler] ADD CONSTRAINT [PK__XMLShipN__FFEE74514C56DBCE] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EDI].[XMLShipNotice_ASNExceptionHandler] ADD CONSTRAINT [UQ__XMLShipN__43FF45804F334879] UNIQUE NONCLUSTERED  ([ASNOverlayGroup]) ON [PRIMARY]
GO
