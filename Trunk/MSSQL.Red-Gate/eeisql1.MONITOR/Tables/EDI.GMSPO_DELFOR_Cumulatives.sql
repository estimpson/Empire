CREATE TABLE [EDI].[GMSPO_DELFOR_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__GMSPO_DEL__Statu__7DB8CDD3] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__GMSPO_DELF__Type__7EACF20C] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyQualifier] [int] NULL,
[CumulativeQty] [int] NULL,
[CumulativeStartDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__7FA11645] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__00953A7E] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__01895EB7] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__027D82F0] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[GMSPO_DELFOR_Cumulatives] ADD CONSTRAINT [PK__GMSPO_DE__FFEE74517BD08561] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
