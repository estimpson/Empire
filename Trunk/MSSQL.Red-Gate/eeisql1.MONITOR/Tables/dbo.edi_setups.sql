CREATE TABLE [dbo].[edi_setups]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[supplier_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trading_partner_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[release_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[auto_create_asn] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[asn_overlay_group] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equipment_description] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pool_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[pool_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_issuer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_code_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_model_year] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_po] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_cum_in_asn] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIShipToID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessEDI] [int] NULL,
[TransitDays] [int] NULL,
[EDIOffsetDays] [int] NULL,
[PlanningReleasesFlag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__edi_setup__Plann__02B22128] DEFAULT ('A'),
[ReferenceAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdjustmentAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckCustomerPOFirm] [int] NULL,
[PlanningReleaseHorizonDaysBack] [int] NULL,
[ShipScheduleHorizonDaysBack] [int] NULL,
[ProcessShipSchedule] [int] NULL,
[ProcessPlanningRelease] [int] NULL,
[IConnectID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create trigger [dbo].[ftr_edi_setups_i] on [dbo].[edi_setups] after insert
as
begin

	-- 03/27/2017 Andre Boulanger FT, LLC. Created trigger becuase Empire does not maintain the column EDIOffsetdays in Monitor
	set noCount On;
	-- declarations
	declare	@destination varchar(20),
			@idCodeType varchar(50)

	-- get first updated/inserted row
	select	@destination = min(destination)
	from	inserted
	-- get id_code_type from inserted row
	select	@idCodeType = min(id_code_type)
	from	inserted
	Where	inserted.destination = @destination

	
	If isNumeric(@idCodeType) = 1 
	begin

		update 	edi_setups 
		set		EDIOffsetDays = @idCodeType
		from 	edi_setups
		where	destination = @destination

	end

end

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create trigger [dbo].[ftr_edi_setups_u] on [dbo].[edi_setups] after update
as
begin

	-- 03/27/2017 Andre Boulanger FT, LLC. Created trigger becuase Empire does not maintain the column EDIOffsetdays in Monitor
	set noCount On;
	-- declarations
	declare	@destination varchar(20),
			@idCodeType varchar(50)

	-- get first updated/inserted row
	select	@destination = min(destination)
	from	inserted
	-- get id_code_type from inserted row
	select	@idCodeType = min(inserted.id_code_type)
	from	inserted
	Join	deleted on deleted.destination = inserted.destination
	Where	inserted.destination = @destination and
			coalesce(deleted.id_code_type,'A') != coalesce(inserted.id_code_type,'B')

	
	If isNumeric(@idCodeType) = 1 
	begin

		update 	edi_setups 
		set		EDIOffsetDays = @idCodeType
		from 	edi_setups
		where	destination = @destination

	end

end

GO
ALTER TABLE [dbo].[edi_setups] ADD CONSTRAINT [PK__edi_setups__1C323631] PRIMARY KEY CLUSTERED  ([destination]) ON [PRIMARY]
GO
