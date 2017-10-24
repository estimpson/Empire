CREATE TABLE [EDI].[TRW_DELFOR_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TRW_DELFO__Statu__698F7790] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TRW_DELFOR__Type__6A839BC9] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ICCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [int] NULL,
[AccumReceived] [int] NULL,
[ReleaseDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TRW_DELFO__RowCr__6B77C002] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELFO__RowCr__6C6BE43B] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TRW_DELFO__RowMo__6D600874] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELFO__RowMo__6E542CAD] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TRW_DELFOR_Releases] ADD CONSTRAINT [PK__TRW_DELF__FFEE745167A72F1E] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
