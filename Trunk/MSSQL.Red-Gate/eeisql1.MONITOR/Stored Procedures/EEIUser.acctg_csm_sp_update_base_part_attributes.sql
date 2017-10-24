SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_update_base_part_attributes] 
(	
@base_part varchar(30), 
@release_id char(7), 
@salesperson varchar(50),
@date_of_award date,
@type_of_award varchar(50),
@family varchar(400), 
@customer varchar(50), 
@parent_customer varchar(50), 
@product_line varchar(25), 
@empire_market_segment varchar(200), 
@empire_market_subsegment varchar(200), 
@empire_application varchar(500), 
@empire_sop smalldatetime, 
@empire_eop smalldatetime, 
@include_in_forecast bit)
as
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
		,include_in_forecast = @include_in_forecast
where base_part = @base_part and release_id = @release_id


GO
