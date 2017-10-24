CREATE TABLE [EDI].[StagingDELFOR_Cumulatives_TELEFLEX]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingDE__Statu__5BF97E03] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingDEL__Type__5CEDA23C] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyQualifier] [int] NULL,
[CumulativeQty] [int] NULL,
[CumulativeStartDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingDE__RowCr__5DE1C675] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingDE__RowCr__5ED5EAAE] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingDE__RowMo__5FCA0EE7] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingDE__RowMo__60BE3320] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingDELFOR_Cumulatives_TELEFLEX] ADD CONSTRAINT [PK__StagingD__FFEE74515A113591] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
