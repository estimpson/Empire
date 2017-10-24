CREATE TABLE [EDI].[TELEFLEX_DELFOR_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TELEFLEX___Statu__7895BCB1] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TELEFLEX_D__Type__7989E0EA] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyQualifier] [int] NULL,
[CumulativeQty] [int] NULL,
[CumulativeStartDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TELEFLEX___RowCr__7A7E0523] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TELEFLEX___RowCr__7B72295C] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TELEFLEX___RowMo__7C664D95] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TELEFLEX___RowMo__7D5A71CE] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TELEFLEX_DELFOR_Cumulatives] ADD CONSTRAINT [PK__TELEFLEX__FFEE745176AD743F] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
