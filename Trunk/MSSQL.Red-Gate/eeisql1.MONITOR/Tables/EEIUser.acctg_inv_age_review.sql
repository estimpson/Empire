CREATE TABLE [EEIUser].[acctg_inv_age_review]
(
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
[new_status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[active_where_used] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inactive_where_used] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[review_note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action_item] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assigned_party] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[service_where_used] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[corrective_action] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[at_risk] [bit] NULL,
[percent_total] [decimal] (18, 6) NULL,
[RM_Net_104_WkDemand] [decimal] (18, 6) NULL,
[Net_RM_104_Wk] [decimal] (18, 6) NULL,
[Net_RM_104_Wk_Material] [decimal] (18, 6) NULL,
[WeeksRemainProduction] [int] NULL CONSTRAINT [DF__acctg_inv__Weeks__1A6E7332] DEFAULT ((0)),
[ExcessOverride] [int] NULL,
[scrap] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_inv_age_review] ADD CONSTRAINT [PK_acctg_inv_age_review] PRIMARY KEY CLUSTERED  ([asofdate], [receivedfiscalyear], [receivedperiod], [part]) ON [PRIMARY]
GO
