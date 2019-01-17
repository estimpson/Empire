SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[acctg_csm_sp_update_base_part_attributes] 
(	
@base_part varchar(30), 
@release_id char(7), 
@salesperson varchar(50),
@date_of_award date = null,
@type_of_award varchar(50),
@family varchar(400), 
@customer varchar(50), 
@parent_customer varchar(50), 
@product_line varchar(25), 
@empire_market_segment varchar(200), 
@empire_market_subsegment varchar(200), 
@empire_application varchar(500), 
@empire_sop smalldatetime = null, 
@empire_eop smalldatetime = null, 
@empire_eop_note varchar(250),
@include_in_forecast bit)
as


if ( (
		select
			coalesce(bpa.empire_eop, '')
		from
			eeiuser.acctg_csm_base_part_attributes bpa
		where
			bpa.base_part = @base_part
			and bpa.release_id = @release_id ) <> coalesce(@empire_eop, '') ) begin

	if (rtrim(@empire_eop_note) = '') begin
		raiserror ('Empire EOP Note is required for an EOP change.', 16, 1)
		return
	end

	if ( ( 
			select
				coalesce(bpa.empire_eop_note, '')
			from
				eeiuser.acctg_csm_base_part_attributes bpa
			where
				bpa.base_part = @base_part
				and bpa.release_id = @release_id ) = coalesce(@empire_eop_note, '') ) begin
		
		raiserror ('Must enter a new Empire EOP Note when changing the EOP.', 16, 1)
		return
	end

end

update eeiuser.acctg_csm_base_part_attributes
set 
		salesperson = @salesperson
		,date_of_award = @date_of_award
		,type_of_award = @type_of_award
		,family = @family
		,customer = @customer
		,parent_customer = @parent_customer
		,product_line = @product_line
		,empire_market_segment = @empire_market_segment
		,empire_market_subsegment = @empire_market_subsegment
		,empire_application = @empire_application
		,empire_sop = @empire_sop
		,empire_eop = @empire_eop
		,empire_eop_note = @empire_eop_note
		,include_in_forecast = @include_in_forecast
where	base_part = @base_part 
	and release_id = @release_id
GO
