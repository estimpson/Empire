CREATE TABLE [EDI].[TELEFLEX_DELFOR_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TELEFLEX___Statu__0C9CB55E] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TELEFLEX_D__Type__0D90D997] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TELEFLEX___RowCr__0E84FDD0] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TELEFLEX___RowCr__0F792209] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TELEFLEX___RowMo__106D4642] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TELEFLEX___RowMo__11616A7B] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TELEFLEX_DELFOR_Releases] ADD CONSTRAINT [PK__TELEFLEX__FFEE74510AB46CEC] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
