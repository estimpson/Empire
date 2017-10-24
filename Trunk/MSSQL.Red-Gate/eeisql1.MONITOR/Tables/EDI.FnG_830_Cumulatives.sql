CREATE TABLE [EDI].[FnG_830_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__FnG_830_C__Statu__28F83193] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__FnG_830_Cu__Type__29EC55CC] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__FnG_830_C__RowCr__2AE07A05] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__FnG_830_C__RowCr__2BD49E3E] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__FnG_830_C__RowMo__2CC8C277] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__FnG_830_C__RowMo__2DBCE6B0] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[FnG_830_Cumulatives] ADD CONSTRAINT [PK__FnG_830___FFEE7451270FE921] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
