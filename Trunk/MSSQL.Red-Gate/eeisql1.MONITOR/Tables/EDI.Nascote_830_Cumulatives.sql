CREATE TABLE [EDI].[Nascote_830_Cumulatives]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Nascote_8__Statu__308FFD11] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Nascote_83__Type__3184214A] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[ShipToCode] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyQualifier] [int] NULL,
[CumulativeQty] [int] NULL,
[CumulativeStartDT] [datetime] NULL,
[CumulativeEndDT] [datetime] NULL,
[LastReceivedQty] [int] NULL,
[LastReceivedDT] [datetime] NULL,
[LastReceivedBOL] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Nascote_8__RowCr__32784583] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Nascote_8__RowCr__336C69BC] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Nascote_8__RowMo__34608DF5] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Nascote_8__RowMo__3554B22E] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[Nascote_830_Cumulatives] ADD CONSTRAINT [PK__Nascote___FFEE74512EA7B49F] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
