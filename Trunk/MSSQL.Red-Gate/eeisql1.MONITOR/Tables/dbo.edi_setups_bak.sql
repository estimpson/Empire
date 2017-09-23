CREATE TABLE [dbo].[edi_setups_bak]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[supplier_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trading_partner_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[release_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[auto_create_asn] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[asn_overlay_group] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equipment_description] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pool_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[pool_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_issuer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_code_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_model_year] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_po] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_cum_in_asn] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIMapCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIShipToID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessEDI] [bit] NULL CONSTRAINT [DF__edi_setup__Proce__2984D547] DEFAULT ((1)),
[TransitDays] [int] NULL,
[EDIOffsetDays] [int] NULL CONSTRAINT [DF__edi_setup__EDIOf__2A78F980] DEFAULT ((0)),
[PlanningReleasesFlag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__edi_setup__Plann__2B6D1DB9] DEFAULT ('A'),
[InboundMapGroup] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InboundProcessGroup] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdjustmentAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckCustomerPOFirm] [bit] NULL,
[PlanningReleaseHorizonDaysBack] [int] NULL,
[ShipScheduleHorizonDaysBack] [int] NULL,
[ProcessShipSchedule] [bit] NULL,
[ProcessPlanningRelease] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_setups_bak] ADD CONSTRAINT [PK__edi_setups__24F264BB] PRIMARY KEY CLUSTERED  ([destination]) ON [PRIMARY]
GO
