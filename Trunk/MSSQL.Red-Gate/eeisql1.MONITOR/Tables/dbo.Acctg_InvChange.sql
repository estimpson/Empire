CREATE TABLE [dbo].[Acctg_InvChange]
(
[Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriorType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorProductLine] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorQuantity] [decimal] (30, 6) NULL,
[PriorCost] [decimal] (30, 6) NULL,
[PriorExtCost] [decimal] (30, 6) NULL,
[CurrentType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentProductLine] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentQuantity] [decimal] (30, 6) NULL,
[CurrentCost] [decimal] (30, 6) NULL,
[CurrentExtCost] [decimal] (30, 6) NULL,
[PeriodChange] [decimal] (30, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Acctg_InvChange] ADD CONSTRAINT [PK_Acctg_InvChange] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idxAcctg_InvChange] ON [dbo].[Acctg_InvChange] ([Part]) ON [PRIMARY]
GO
