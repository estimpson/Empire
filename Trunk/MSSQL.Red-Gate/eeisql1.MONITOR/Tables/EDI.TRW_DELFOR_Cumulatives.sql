CREATE TABLE [EDI].[TRW_DELFOR_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TRW_DELFO__Statu__5FDE5229] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TRW_DELFOR__Type__60D27662] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ReleaseNo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToCode] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyQualifier] [int] NULL,
[CumulativeQty] [int] NULL,
[CumulativeStartDT] [datetime] NULL,
[CumulativeEndDT] [datetime] NULL,
[LastReceivedQty] [int] NULL,
[LastReceivedDT] [datetime] NULL,
[LastReceivedDocumentID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TRW_DELFO__RowCr__61C69A9B] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELFO__RowCr__62BABED4] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TRW_DELFO__RowMo__63AEE30D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELFO__RowMo__64A30746] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TRW_DELFOR_Cumulatives] ADD CONSTRAINT [PK__TRW_DELF__FFEE74515DF609B7] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
