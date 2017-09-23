CREATE TABLE [EDI].[TRW_DELJIT_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TRW_DELJI__Statu__64FFCC9D] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TRW_DELJIT__Type__65F3F0D6] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipFromCode] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DockCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineFeedCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReserveLineFeedCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseQty] [int] NULL,
[ReleaseDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TRW_DELJI__RowCr__66E8150F] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELJI__RowCr__67DC3948] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TRW_DELJI__RowMo__68D05D81] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELJI__RowMo__69C481BA] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TRW_DELJIT_Releases] ADD CONSTRAINT [PK__TRW_DELJ__FFEE74516317842B] PRIMARY KEY CLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
