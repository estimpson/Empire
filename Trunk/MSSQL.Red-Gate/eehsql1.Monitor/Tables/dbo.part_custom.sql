CREATE TABLE [dbo].[part_custom]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eau] [int] NULL,
[imds] [int] NULL,
[longest_lt] [int] NULL,
[critical_part] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[criticalpartnotes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auto_releases] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weeks_to_freeze] [smallint] NULL,
[generate_mr] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prod_pre_end] [smallint] NULL,
[tb_pricing] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[backdays] [int] NULL,
[quoted_bom_cost] [numeric] (20, 6) NULL,
[prod_bom_cost] [numeric] (20, 6) NULL,
[sales_return_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinutestoApproveBox] [numeric] (20, 6) NULL,
[Expedite] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpediteQty] [numeric] (20, 6) NULL,
[CriticalQty] [numeric] (20, 6) NULL,
[Max_Receipt_Authorized] [numeric] (20, 6) NULL,
[Restrict_Production_To_StandarPack] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__part_cust__Restr__7D67C0CB] DEFAULT ('N'),
[DateChangeMaxReceiptAutorized] [datetime] NULL,
[Require_Lot] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__part_cust__Requi__7E5BE504] DEFAULT ('N'),
[OEM] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Scrap_Factor] [numeric] (22, 10) NULL CONSTRAINT [DF__part_cust__Scrap__7F50093D] DEFAULT ((0)),
[LastUpdateBy] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdateDT] [datetime] NULL,
[Restrict_Transfer_To_StandarPack] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__part_cust__Restr__00442D76] DEFAULT ('N')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_custom] ADD CONSTRAINT [PK__part_cus__8320BCD27095C2A6] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
