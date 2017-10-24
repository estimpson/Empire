SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[ftsp_restore_RTVSerials_byShipper] ( @Shipper int)
as
Begin

--Get Object data into temp data store for insert back into object table
--   ftsp_restore_RTVSerials_byShipper 97871
Select * 
	into #AuditTrail
From 
	audit_trail
Where 
	shipper = convert( varchar(25), @Shipper )
	

INSERT INTO [object]
           ([serial]
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
           ,[posted])
	
	
	Select  
	
			[serial]
           ,[part]
           ,'EEI-QC'
           ,GETDATE()
           ,Unit
           ,'ASB'
           ,'A'
           ,[destination]
           ,NULL
           ,[origin]
           ,[cost]
           ,[weight]
           ,[parent_serial]
           ,'Restored via SQL Script'
           ,[quantity]
           ,GETDATE()
           ,NULL
           ,[customer]
           ,[sequence]
           ,[shipper]
           ,[lot]
           ,[type]
           ,[po_number]
           ,NULL
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
           ,NULL
           
           From
           
           #auditTrail [AuditTrail]
           
          Delete audit_trail where type = 'V' and shipper = CONVERT(varchar(10), @Shipper)
         
         Delete shipper_detail where shipper =  @Shipper
         
         Update shipper set status = 'E' , notes =  'Deleted RTV items via SQL - asb 04/12/2016'  where id =  @Shipper
         
          
           
           
	
	
	
	
	End
GO
