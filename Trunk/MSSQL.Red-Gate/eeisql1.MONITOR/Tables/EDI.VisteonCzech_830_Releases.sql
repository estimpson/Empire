CREATE TABLE [EDI].[VisteonCzech_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__VisteonCz__Statu__02169BF8] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__VisteonCze__Type__030AC031] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ICCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [int] NULL,
[ReleaseDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowCr__03FEE46A] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowCr__04F308A3] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__VisteonCz__RowMo__05E72CDC] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__VisteonCz__RowMo__06DB5115] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[VisteonCzech_830_Releases] ADD CONSTRAINT [PK__VisteonC__FFEE7451002E5386] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_VisteonCzech_830_Releases_1] ON [EDI].[VisteonCzech_830_Releases] ([Status], [RawDocumentGUID], [ShipToCode], [ShipFromCode], [ICCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
