SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[OBS_dw_eeisp_rpt_inventory_change200604]

as

begin

-- Clear the rows from the permanent table to allow repopulation
	
TRUNCATE TABLE			Acctg_InvChange


-- Create the table to store prior month inventory	
			
	Create table 		#PriorMonthInv	(
						Part			varchar(50),
						PriorType		char(1),
						PriorProductLine	varchar(25),
						PriorQuantity		decimal(30,6),
						PriorCost		decimal(30,6),
						PriorExtCost		decimal(30,6)
						)
				
		Create index 	idxPriorMonthInv on #PriorMonthInv(Part)
		

-- Populate the table

	Insert 		#PriorMonthInv

			select 		object_copy_20060331.part,
						part_copy_20060331.type,
						part_copy_20060331.product_line,
						sum(object_copy_20060331.quantity),
						part_standard_copy_20060331.material_cum,
						sum(object_copy_20060331.quantity*part_standard_copy_20060331.material_cum) 
										
			from 		object_copy_20060331
	
			left outer join		part_copy_20060331 on object_copy_20060331.part = part_copy_20060331.part
			left outer join		part_standard_copy_20060331 on object_copy_20060331.part = part_standard_copy_20060331.part
	
			Where		part_copy_20060331.type not in ('R', 'W', '') and
						object_copy_20060331.serial not in (
'178763',
'94517',
'103544',
'119881',
'119882',
'119883',
'89316',
'107350',
'89317',
'107351',
'58663',
'169376',
'81360',
'296138',
'205497',
'206718',
'206719',
'207305',
'191004',
'191005',
'191464',
'191465',
'191467',
'230448',
'230712',
'230713',
'230714',
'230715',
'230821',
'231179',
'231180',
'231181',
'231182',
'231183',
'231184',
'231185',
'231186',
'231187',
'231188',
'231258',
'231259',
'231261',
'191003',
'191735',
'191737',
'191854',
'191855',
'192925',
'192926',
'193101',
'196286',
'230369',
'230370',
'230371',
'230526',
'230527',
'230528',
'230529',
'230530',
'230531',
'230532',
'230533',
'230534',
'230535',
'230710',
'230711',
'230816',
'230817',
'230818',
'230819',
'230820',
'231260',
'399502',
'395019',
'424912',
'375478',
'377756',
'375479',
'377757',
'422560',
'422559',
'422563',
'422566',
'422568',
'422573',
'422578',
'422580',
'422581',
'370087',
'410397',
'397217',
'403382',
'329039',
'418333',
'422583',
'372511',
'403940',
'319719',
'394564',
'422564',
'422582',
'422579'
)

			group by	object_copy_20060331.part,
						part_copy_20060331.type,
						part_copy_20060331.product_line,
						part_standard_copy_20060331.material_cum
															
			order by 	1


-- Create the table to store current month inventory

	Create table 		#CurrentMonthInv(
						Part			varchar(50),
						CurrentType		char(1),
						CurrentProductLine	varchar(25),
						CurrentQuantity		decimal(30,6),
						CurrentCost		decimal(30,6),
						CurrentExtCost		decimal(30,6)
						)
				
		Create index 	idxCurrentMonthInv on #CurrentMonthInv(Part)
	

-- Populate the table
		
		Insert		 #CurrentMonthInv
			
			select 		object_copy_20060430.part,
						part_copy_20060430.type,
						part_copy_20060430.product_line,
						sum(object_copy_20060430.quantity),
						part_standard_copy_20060430.material_cum,
						sum(object_copy_20060430.quantity*part_standard_copy_20060430.material_cum)
										
			from 		object_copy_20060430

			left outer join		part_copy_20060430 on object_copy_20060430.part = part_copy_20060430.part
			left outer join 	part_standard_copy_20060430 on object_copy_20060430.part = part_standard_copy_20060430.part

			Where		part_copy_20060430.type not in ('R', 'W', '')

			group by	object_copy_20060430.part,
						part_copy_20060430.type,
						part_copy_20060430.product_line,
						part_standard_copy_20060430.material_cum
															
			order by 	1


-- The following permanent table was created to compare the inventory on hand from the current to prior month

--	Create table 		Acctg_InvChange 	(
--						Part			varchar(50),
--						PriorType		char(1),
--						PriorProductLine	varchar(25),
--						PriorQuantity		decimal(30,6),
--						PriorCost		decimal(30,6),
--  					PriorExtCost 		decimal(30,6),
--						CurrentType		char(1),
--						CurrentProductLine	varchar(25),
--						CurrentQuantity		decimal(30,6),
--						CurrentCost		decimal(30,6),
--						CurrentExtCost		decimal(30,6),
--						PeriodChange		decimal(30,6)
--						)
--				
--		Create index 	idxAcctg_InvChange on Acctg_InvChange(Part)


-- Populate the table					

-- Add prior month inventory and current month inventory
					
		Insert		Acctg_InvChange

			select		#PriorMonthInv.part,
					isNULL(#PriorMonthInv.PriorType,''),
					isNULL(#PriorMonthInv.PriorProductLine,''),
					isNULL(#PriorMonthInv.PriorQuantity,0),
					isNULL(#PriorMonthInv.PriorCost,0),
					isNULL(#PriorMonthInv.PriorExtCost,0),
					isNULL(#CurrentMonthInv.CurrentType,''),
					isNULL(#CurrentMonthInv.CurrentProductLine,''),
					isNULL(#CurrentMonthInv.CurrentQuantity,0),
					isNULL(#CurrentMonthInv.CurrentCost,0),
					isNULL(#CurrentMonthInv.CurrentExtCost,0),
					0
		
			from		#PriorMonthInv
							
			Left outer join	#CurrentMonthInv on #PriorMonthInv.part = #CurrentMonthInv.part


-- Update table with current month inventory where no prior month inventory

		Insert		Acctg_InvChange

			select		#CurrentMonthInv.part,
					isNULL(#PriorMonthInv.PriorType,''),
					isNULL(#PriorMonthInv.PriorProductLine,''),
					isNULL(#PriorMonthInv.PriorQuantity,0),
					isNULL(#PriorMonthInv.PriorCost,0),
					isNULL(#PriorMonthInv.PriorExtCost,0),
					isNULL(#CurrentMonthInv.CurrentType,''),
					isNULL(#CurrentMonthInv.CurrentProductLine,''),
					isNULL(#CurrentMonthInv.CurrentQuantity,0),
					isNULL(#CurrentMonthInv.CurrentCost,0),
					isNULL(#CurrentMonthInv.CurrentExtCost,0),
					0
		
			from		#CurrentMonthInv
										
			Left outer join	#PriorMonthInv on #CurrentMonthInv.part = #PriorMonthInv.part

			where		#CurrentMonthInv.part not in (select Acctg_InvChange.part from Acctg_InvChange)


-- Update table for instances of current month activity but no current month or prior month ending inventory

		Insert		Acctg_InvChange

			select		DISTINCT(gl_cost_transactions.document_reference1),
					'',
					'',
					0,
					0,
					0,
					'',
					'',
					0,
					0,
					0,
					0

			from	gl_cost_transactions
						
			where	gl_cost_transactions.ledger = 'EMPIRE' and
					gl_cost_transactions.fiscal_year = '2006' and
					gl_cost_transactions.period = 4 and
					gl_cost_transactions.ledger_account in ('153111','154011','154111') and
					gl_cost_transactions.update_balances = 'Y' and
					gl_cost_transactions.document_reference1 not in (select Acctg_InvChange.part from Acctg_InvChange)


-- Add product_line

		Update		Acctg_InvChange

			set		CurrentType = part_copy_20060430.type,
					CurrentProductLine = part_copy_20060430.Product_Line

			from	Acctg_InvChange

			left outer join part_copy_20060430 on Acctg_InvChange.part = part_copy_20060430.part



-- Calculate period change

		Update		Acctg_InvChange

			set		PeriodChange = CurrentExtCost-PriorExtCost


End

--		Select *, Acctg_InvChange.CurrentExtCost-Acctg_InvChange.PriorExtCost from Acctg_InvChange	

--		Order by 1


					
				
					
GO
