SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_update_material_cost_unpivot]
--	@OperatorCode varchar(5)
	@Release_ID char(7)
,	@Base_Part varchar(30)
,	@PartUsedForCost varchar(25)

,	@Jan2017 decimal(10,6) 
,	@Feb2017 decimal(10,6) 
,	@Mar2017 decimal(10,6) 
,	@Apr2017 decimal(10,6) 
,	@May2017 decimal(10,6) 
,	@Jun2017 decimal(10,6) 
,	@Jul2017 decimal(10,6) 
,	@Aug2017 decimal(10,6) 
,	@Sep2017 decimal(10,6) 
,	@Oct2017 decimal(10,6) 
,	@Nov2017 decimal(10,6) 
,	@Dec2017 decimal(10,6)
,	@Total_2017 decimal(10,6) 

,	@Jan2018 decimal(10,6) 
,	@Feb2018 decimal(10,6) 
,	@Mar2018 decimal(10,6) 
,	@Apr2018 decimal(10,6) 
,	@May2018 decimal(10,6) 
,	@Jun2018 decimal(10,6) 
,	@Jul2018 decimal(10,6) 
,	@Aug2018 decimal(10,6) 
,	@Sep2018 decimal(10,6) 
,	@Oct2018 decimal(10,6) 
,	@Nov2018 decimal(10,6) 
,	@Dec2018 decimal(10,6)
,	@Total_2018 decimal(10,6)

,	@Jan2019 decimal(10,6) 
,	@Feb2019 decimal(10,6) 
,	@Mar2019 decimal(10,6) 
,	@Apr2019 decimal(10,6) 
,	@May2019 decimal(10,6) 
,	@Jun2019 decimal(10,6) 
,	@Jul2019 decimal(10,6) 
,	@Aug2019 decimal(10,6) 
,	@Sep2019 decimal(10,6) 
,	@Oct2019 decimal(10,6) 
,	@Nov2019 decimal(10,6) 
,	@Dec2019 decimal(10,6)
,	@Total_2019 decimal(10,6)
  
,	@Jan2020 decimal(10,6) 
,	@Feb2020 decimal(10,6) 
,	@Mar2020 decimal(10,6) 
,	@Apr2020 decimal(10,6) 
,	@May2020 decimal(10,6) 
,	@Jun2020 decimal(10,6) 
,	@Jul2020 decimal(10,6) 
,	@Aug2020 decimal(10,6) 
,	@Sep2020 decimal(10,6) 
,	@Oct2020 decimal(10,6) 
,	@Nov2020 decimal(10,6) 
,	@Dec2020 decimal(10,6)
,	@Total_2020 decimal(10,6) 

,	@Jan2021 decimal(10,6) 
,	@Feb2021 decimal(10,6) 
,	@Mar2021 decimal(10,6) 
,	@Apr2021 decimal(10,6) 
,	@May2021 decimal(10,6) 
,	@Jun2021 decimal(10,6) 
,	@Jul2021 decimal(10,6) 
,	@Aug2021 decimal(10,6) 
,	@Sep2021 decimal(10,6) 
,	@Oct2021 decimal(10,6) 
,	@Nov2021 decimal(10,6) 
,	@Dec2021 decimal(10,6)
,	@Total_2021 decimal(10,6) 

/*
,	@Jan2022 decimal(10,6) 
,	@Feb2022 decimal(10,6) 
,	@Mar2022 decimal(10,6) 
,	@Apr2022 decimal(10,6) 
,	@May2022 decimal(10,6) 
,	@Jun2022 decimal(10,6) 
,	@Jul2022 decimal(10,6) 
,	@Aug2022 decimal(10,6) 
,	@Sep2022 decimal(10,6) 
,	@Oct2022 decimal(10,6) 
,	@Nov2022 decimal(10,6) 
,	@Dec2022 decimal(10,6)
*/
   
,	@Total_2022 decimal(10,6)  
,	@Total_2023 decimal(10,6)
,	@Total_2024 decimal(10,6)
,	@Total_2025 decimal(10,6)
,	@Total_2026 decimal(10,6)

,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>


---	<ArgumentValidation>
--if not exists (
--		select
--			*
--		from
--			dbo.employee e
--		where	
--			e.operator_code = @OperatorCode ) begin

--	set	@Result = 999999
--	RAISERROR ('Invalid operator code.  Procedure %s.', 16, 1, @ProcName)
--	rollback tran @ProcName
--	return
--end
---	</ArgumentValidation>


--- <Body>
--- <Update rows>
set	@TableName = 'eeiuser.acctg_csm_material_cost_detail'	
update
	eeiuser.acctg_csm_material_cost_detail
set
	MaterialCost =
		case
			when EffectiveYear = 2017 and Period = 'M01' then @Jan2017
			when EffectiveYear = 2017 and Period = 'M02' then @Feb2017
			when EffectiveYear = 2017 and Period = 'M03' then @Mar2017
			when EffectiveYear = 2017 and Period = 'M04' then @Apr2017
			when EffectiveYear = 2017 and Period = 'M05' then @May2017
			when EffectiveYear = 2017 and Period = 'M06' then @Jun2017
			when EffectiveYear = 2017 and Period = 'M07' then @Jul2017
			when EffectiveYear = 2017 and Period = 'M08' then @Aug2017
			when EffectiveYear = 2017 and Period = 'M09' then @Sep2017
			when EffectiveYear = 2017 and Period = 'M10' then @Oct2017
			when EffectiveYear = 2017 and Period = 'M11' then @Nov2017
			when EffectiveYear = 2017 and Period = 'M12' then @Dec2017

			when EffectiveYear = 2018 and Period = 'M01' then @Jan2018
			when EffectiveYear = 2018 and Period = 'M02' then @Feb2018
			when EffectiveYear = 2018 and Period = 'M03' then @Mar2018
			when EffectiveYear = 2018 and Period = 'M04' then @Apr2018
			when EffectiveYear = 2018 and Period = 'M05' then @May2018
			when EffectiveYear = 2018 and Period = 'M06' then @Jun2018
			when EffectiveYear = 2018 and Period = 'M07' then @Jul2018
			when EffectiveYear = 2018 and Period = 'M08' then @Aug2018
			when EffectiveYear = 2018 and Period = 'M09' then @Sep2018
			when EffectiveYear = 2018 and Period = 'M10' then @Oct2018
			when EffectiveYear = 2018 and Period = 'M11' then @Nov2018
			when EffectiveYear = 2018 and Period = 'M12' then @Dec2018

			when EffectiveYear = 2019 and Period = 'M01' then @Jan2019
			when EffectiveYear = 2019 and Period = 'M02' then @Feb2019
			when EffectiveYear = 2019 and Period = 'M03' then @Mar2019
			when EffectiveYear = 2019 and Period = 'M04' then @Apr2019
			when EffectiveYear = 2019 and Period = 'M05' then @May2019
			when EffectiveYear = 2019 and Period = 'M06' then @Jun2019
			when EffectiveYear = 2019 and Period = 'M07' then @Jul2019
			when EffectiveYear = 2019 and Period = 'M08' then @Aug2019
			when EffectiveYear = 2019 and Period = 'M09' then @Sep2019
			when EffectiveYear = 2019 and Period = 'M10' then @Oct2019
			when EffectiveYear = 2019 and Period = 'M11' then @Nov2019
			when EffectiveYear = 2019 and Period = 'M12' then @Dec2019

			when EffectiveYear = 2020 and Period = 'M01' then @Jan2020
			when EffectiveYear = 2020 and Period = 'M02' then @Feb2020
			when EffectiveYear = 2020 and Period = 'M03' then @Mar2020
			when EffectiveYear = 2020 and Period = 'M04' then @Apr2020
			when EffectiveYear = 2020 and Period = 'M05' then @May2020
			when EffectiveYear = 2020 and Period = 'M06' then @Jun2020
			when EffectiveYear = 2020 and Period = 'M07' then @Jul2020
			when EffectiveYear = 2020 and Period = 'M08' then @Aug2020
			when EffectiveYear = 2020 and Period = 'M09' then @Sep2020
			when EffectiveYear = 2020 and Period = 'M10' then @Oct2020
			when EffectiveYear = 2020 and Period = 'M11' then @Nov2020
			when EffectiveYear = 2020 and Period = 'M12' then @Dec2020

			when EffectiveYear = 2021 and Period = 'M01' then @Jan2021
			when EffectiveYear = 2021 and Period = 'M02' then @Feb2021
			when EffectiveYear = 2021 and Period = 'M03' then @Mar2021
			when EffectiveYear = 2021 and Period = 'M04' then @Apr2021
			when EffectiveYear = 2021 and Period = 'M05' then @May2021
			when EffectiveYear = 2021 and Period = 'M06' then @Jun2021
			when EffectiveYear = 2021 and Period = 'M07' then @Jul2021
			when EffectiveYear = 2021 and Period = 'M08' then @Aug2021
			when EffectiveYear = 2021 and Period = 'M09' then @Sep2021
			when EffectiveYear = 2021 and Period = 'M10' then @Oct2021
			when EffectiveYear = 2021 and Period = 'M11' then @Nov2021
			when EffectiveYear = 2021 and Period = 'M12' then @Dec2021

			-- Calculated year
			when EffectiveYear = 2022 and Period = 'CY' then @Total_2022
			when EffectiveYear = 2023 and Period = 'CY' then @Total_2023
			when EffectiveYear = 2024 and Period = 'CY' then @Total_2024
			when EffectiveYear = 2025 and Period = 'CY' then @Total_2025
			when EffectiveYear = 2026 and Period = 'CY' then @Total_2026
		end
where
	Release_ID = @Release_ID
	and BasePart = @Base_Part
	and Row_ID = 1
	and EffectiveYear >= 2017


select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update rows>
--- </Body>



---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>



GO
