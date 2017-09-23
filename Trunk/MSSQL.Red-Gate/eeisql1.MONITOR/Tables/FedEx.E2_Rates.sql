CREATE TABLE [FedEx].[E2_Rates]
(
[Weight] [int] NULL,
[Zone02] [decimal] (10, 2) NULL,
[Zone03] [decimal] (10, 2) NULL,
[Zone04] [decimal] (10, 2) NULL,
[Zone05] [decimal] (10, 2) NULL,
[Zone06] [decimal] (10, 2) NULL,
[Zone07] [decimal] (10, 2) NULL,
[Zone08] [decimal] (10, 2) NULL,
[Zone09] [decimal] (10, 2) NULL,
[Zone10] [decimal] (10, 2) NULL,
[Zone11] [decimal] (10, 2) NULL,
[Zone12] [decimal] (10, 2) NULL,
[Zone13] [decimal] (10, 2) NULL,
[Zone14] [decimal] (10, 2) NULL,
[Zone15] [decimal] (10, 2) NULL,
[Zone16] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF_E2_Rates_Status] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__E2Rates__RowCreateDT] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__E2Rates__RowCreateUser] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__E2Rates__RowModifiedDT] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__E2Rates__RowModifiedUser] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[E2_Rates] ADD CONSTRAINT [PK_E2RatesRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
