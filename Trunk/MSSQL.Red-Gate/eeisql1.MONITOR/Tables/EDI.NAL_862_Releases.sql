CREATE TABLE [EDI].[NAL_862_Releases]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NAL_862_R__Statu__692A2746] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NAL_862_Re__Type__6A1E4B7F] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NAL_862_R__RowCr__6B126FB8] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_862_R__RowCr__6C0693F1] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NAL_862_R__RowMo__6CFAB82A] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NAL_862_R__RowMo__6DEEDC63] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[NAL_862_Releases] ADD CONSTRAINT [PK__NAL_862___FFEE74516741DED4] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
