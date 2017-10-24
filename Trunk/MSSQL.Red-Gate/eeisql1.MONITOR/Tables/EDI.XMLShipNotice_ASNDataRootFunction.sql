CREATE TABLE [EDI].[XMLShipNotice_ASNDataRootFunction]
(
[ASNOverlayGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__XMLShipNo__Statu__55013068] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__XMLShipNot__Type__55F554A1] DEFAULT ((0)),
[FunctionName] [sys].[sysname] NOT NULL,
[CompleteFlagDefault] [int] NOT NULL CONSTRAINT [DF__XMLShipNo__Compl__56E978DA] DEFAULT ((0)),
[FTPMailBoxDefault] [int] NOT NULL CONSTRAINT [DF__XMLShipNo__FTPMa__57DD9D13] DEFAULT ((1)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__XMLShipNo__RowCr__58D1C14C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__XMLShipNo__RowCr__59C5E585] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__XMLShipNo__RowMo__5ABA09BE] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__XMLShipNo__RowMo__5BAE2DF7] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[XMLShipNotice_ASNDataRootFunction] ADD CONSTRAINT [PK__XMLShipN__FFEE74515D967669] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EDI].[XMLShipNotice_ASNDataRootFunction] ADD CONSTRAINT [UQ__XMLShipN__43FF45806072E314] UNIQUE NONCLUSTERED  ([ASNOverlayGroup]) ON [PRIMARY]
GO
