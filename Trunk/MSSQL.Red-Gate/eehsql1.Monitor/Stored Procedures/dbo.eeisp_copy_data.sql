SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure
[dbo].[eeisp_copy_data]
/*(	@Argument1 datetime,*/
/*	@Argument2 varchar(25),*/
/*	@Argumant3 varchar (25))*/
as
begin

declare @rundate datetime;
select @rundate = getdate();

  insert into historicaldata.dbo.part_historical
    select 
		@rundate
	  ,convert(varchar(5),datepart(YYYY, getdate()))
	  ,convert(smallint,datepart(MM, getdate()))
	  ,'MONTH END'
	  ,[part]
      ,[name]
      ,[cross_ref]
      ,[class]
      ,[type]
      ,[commodity]
      ,[group_technology]
      ,[quality_alert]
      ,[description_short]
      ,[description_long]
      ,[serial_type]
      ,[product_line]
      ,[configuration]
      ,[standard_cost]
      ,[user_defined_1]
      ,[user_defined_2]
      ,[flag]
      ,[engineering_level]
      ,[drawing_number]
      ,[gl_account_code]
      ,[eng_effective_date]
      ,[low_level_code] 
	  ,'Y'
	  ,[QualityAlertAutoApproval]
	  ,[QualityAlertAutoApprovalHrs]
	  ,[QualityAlertExpiryDate]
	from part

  insert into historicaldata.dbo.part_standard_historical
    select
		@rundate,
		convert(varchar(5),datepart(YYYY, getdate())),
		convert(smallint,datepart(MM, getdate())),
		'MONTH END',
		[part]
      ,[price]
      ,[cost]
      ,[account_number]
      ,[material]
      ,[labor]
      ,[burden]
      ,[other]
      ,[cost_cum]
      ,[material_cum]
      ,[burden_cum]
      ,[other_cum]
      ,[labor_cum]
      ,[flag]
      ,[premium]
      ,[qtd_cost]
      ,[qtd_material]
      ,[qtd_labor]
      ,[qtd_burden]
      ,[qtd_other]
      ,[qtd_cost_cum]
      ,[qtd_material_cum]
      ,[qtd_labor_cum]
      ,[qtd_burden_cum]
      ,[qtd_other_cum]
      ,[planned_cost]
      ,[planned_material]
      ,[planned_labor]
      ,[planned_burden]
      ,[planned_other]
      ,[planned_cost_cum]
      ,[planned_material_cum]
      ,[planned_labor_cum]
      ,[planned_burden_cum]
      ,[planned_other_cum]
      ,[frozen_cost]
      ,[frozen_material]
      ,[frozen_burden]
      ,[frozen_labor]
      ,[frozen_other]
      ,[frozen_cost_cum]
      ,[frozen_material_cum]
      ,[frozen_burden_cum]
      ,[frozen_labor_cum]
      ,[frozen_other_cum]
      ,[cost_changed_date]
      ,[qtd_changed_date]
      ,[planned_changed_date]
      ,[frozen_changed_date]
      ,[LastUser]
      ,[LastChangeOfCost]
	from part_standard

insert	historicaldata.dbo.object_historical	
				
	select	@rundate
			,convert(varchar(5),datepart(YYYY, getdate()))
			,convert(smallint,datepart(MM, getdate()))
			,'MONTH END'						
			,[serial]
			,[part]
			,[location]
			,[last_date]
			,[unit_measure]
			,[operator]
			,[status]
			,[destination]
			,[station]
			,[origin]
			,[cost]
			,[weight]
			,[parent_serial]
			,[note]
			,[quantity]
			,[last_time]
			,[date_due]
			,[customer]
			,[sequence]
			,[shipper]
			,[lot]
			,[type]
			,[po_number]
			,[name]
			,[plant]
			,[start_date]
			,[std_quantity]
			,[package_type]
			,[field1]
			,[field2]
			,[custom1]
			,[custom2]
			,[custom3]
			,[custom4]
			,[custom5]
			,[show_on_shipper]
			,[tare_weight]
			,[suffix]
			,[std_cost]
			,[user_defined_status]
			,[workorder]
			,[engineering_level]
			,[kanban_number]
			,[dimension_qty_string]
			,[dim_qty_string_other]
			,[varying_dimension_code]
			,[posted]
			,[HumiditySensorValue]
			,NULL
			,NULL
			,NULL
			,NULL
			,[objectBirthDate]
			,[SupplierLot]
	from	object

--insert into po_receiver_items_historical
--	select 		
--		@rundate,
--		convert(varchar(5),datepart(YYYY, getdate())),
--		convert(smallint,datepart(MM, getdate())),
--		'MONTH END',
--		[purchase_order]
--      ,[bill_of_lading]
--      ,[bol_line]
--      ,[receiver]
--      ,[invoice]
--      ,[inv_line]
--      ,[item]
--      ,[approved]
--      ,[receiver_comments]
--      ,[ledger_account_code]
--      ,[quantity_received]
--      ,[unit_cost]
--      ,[changed_date]
--      ,[changed_user_id]
--      ,[total_cost]
--      ,[item_description]
--      ,[container_id]
--      ,[package]
--      ,[country_of_origin]
--      ,[freight_cost]
--      ,[other_cost] 
--	from po_receiver_items

end


GO
