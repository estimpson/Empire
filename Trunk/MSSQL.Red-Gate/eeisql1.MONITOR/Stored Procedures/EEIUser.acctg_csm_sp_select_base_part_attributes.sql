SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_csm_sp_select_base_part_attributes] (@base_part varchar(30), @release_id char(7))
as
select  salesperson
		,date_of_award
		,type_of_award
		,family
		,customer
		,parent_customer
		,product_line
		,empire_market_segment
		,empire_market_subsegment
		,empire_application
		,empire_sop
		,empire_eop
		,include_in_forecast
From eeiuser.acctg_csm_base_part_attributes
where base_part = @base_part and release_id = @release_id




GO
