CREATE TABLE [EDI].[NAL_830_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NAL_830_R__Statu__48134C3E] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NAL_830_Re__Type__49077077] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NAL_830_R__RowCr__49FB94B0] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_830_R__RowCr__4AEFB8E9] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NAL_830_R__RowMo__4BE3DD22] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_830_R__RowMo__4CD8015B] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[NAL_830_Releases] ADD CONSTRAINT [PK__NAL_830___FFEE7451462B03CC] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_NAL_830_Releases_1] ON [EDI].[NAL_830_Releases] ([Status], [RawDocumentGUID], [ShipToCode], [ShipFromCode], [ICCode]) INCLUDE ([CustomerPart]) ON [PRIMARY]
GO
