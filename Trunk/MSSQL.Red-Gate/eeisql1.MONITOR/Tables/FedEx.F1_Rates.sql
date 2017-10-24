CREATE TABLE [FedEx].[F1_Rates]
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
[Status] [int] NULL CONSTRAINT [DF_F1_Rates_Status] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__F1Rates__RowCreateDT] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__F1Rates__RowCreateUser] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__F1Rates__RowModifiedDT] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__F1Rates__RowModifiedUser] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[F1_Rates] ADD CONSTRAINT [PK_F1RatesRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[F1_Rates] ADD CONSTRAINT [UQ__F1_Rates__CAD8CB4E436F23E1] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
