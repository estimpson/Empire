CREATE TABLE [EEIUser].[acctg_inv_age_review_Explotion]
(
[Serial] [int] NOT NULL,
[asofdate] [datetime] NOT NULL,
[receivedfiscalyear] [int] NOT NULL,
[receivedperiod] [int] NOT NULL,
[default_vendor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[commodity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [decimal] (18, 6) NULL,
[ext_material_cum] [decimal] (18, 6) NULL,
[std_pack] [decimal] (18, 6) NULL,
[min_order_qty] [decimal] (18, 6) NULL,
[min_empire_sop] [datetime] NULL,
[max_empire_eop] [datetime] NULL,
[fg_on_hand] [decimal] (18, 6) NULL,
[FG_Net_20_Wk_Demand] [decimal] (18, 6) NULL,
[FG_Net_Avg_Wk_Demand] [decimal] (18, 6) NULL,
[RM_Net_20_Wk_Demand] [decimal] (18, 6) NULL,
[RM_Net_Avg_Wk_Demand] [decimal] (18, 6) NULL,
[weeks_to_exhaust] [decimal] (18, 6) NULL,
[exhaust_date] [datetime] NULL,
[classification] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[on_hold] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[active_demand] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[max_date_material_issued] [datetime] NULL,
[category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[active_where_used] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[service_where_used] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inactive_where_used] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[review_note] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assigned_party] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[corrective_action] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[at_risk] [bit] NULL,
[percent_total] [decimal] (18, 6) NULL,
[RM_Net_104_WkDemand] [decimal] (18, 6) NULL,
[Net_RM_104_Wk] [decimal] (18, 6) NULL,
[Net_RM_104_Wk_Material] [decimal] (18, 6) NULL,
[scrap] [bit] NULL CONSTRAINT [DF__acctg_inv__scrap__66B8601E] DEFAULT ((0)),
[WeeksRemainProduction] [int] NULL CONSTRAINT [DF__acctg_inv__Weeks__67AC8457] DEFAULT ((0)),
[Location] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[last_date] [datetime] NULL,
[objectbirthday] [datetime] NULL,
[Idle_status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryIdle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Area] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Scheduler] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [int] NULL,
[ExcessOverride] [int] NULL
) ON [PRIMARY]
GO
