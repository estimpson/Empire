CREATE TABLE [dbo].[part_eecustom_eei]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[eau] [int] NULL,
[imds] [int] NULL,
[longest_lt] [int] NULL,
[min_prod_run] [numeric] (20, 6) NULL,
[critical_part] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[criticalpartnotes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[auto_releases] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weeks_to_freeze] [smallint] NULL,
[prod_start] [datetime] NULL,
[prod_end] [datetime] NULL,
[generate_mr] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship_note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_ship_operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prod_pre_end] [smallint] NULL,
[tb_pricing] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link1] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link2] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link3] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link4] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link5] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link6] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link7] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link8] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link9] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[link10] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[backdays] [int] NULL,
[ppap_expdt] [datetime] NULL,
[std_hours] [numeric] (20, 6) NULL,
[quoted_bom_cost] [numeric] (20, 6) NULL,
[prod_bom_cost] [numeric] (20, 6) NULL,
[team_no] [int] NULL,
[non_order_status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_order_note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[non_order_operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_return_account] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[minutestoapprovebox] [numeric] (20, 6) NULL,
[expedite] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[servicepart] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currentrevlevel] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[foreignproduct] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lowvolume] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_eecustom_eei] ADD CONSTRAINT [part_eecustom_x] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
