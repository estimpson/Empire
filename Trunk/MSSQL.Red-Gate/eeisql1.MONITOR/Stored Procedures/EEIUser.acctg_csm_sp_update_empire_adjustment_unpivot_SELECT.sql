SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_csm_sp_update_empire_adjustment_unpivot_SELECT]
--	@OperatorCode varchar(5)
	@Release_ID char(7)
,	@MnemonicVehiclePlant varchar(30)
,	@Platform varchar(255)
,	@Program varchar(255)
,	@Vehicle varchar(50)
,	@Plant varchar(255)
,	@Sop datetime
,	@Eop datetime

,	@Version varchar(30)
,	@Qty_Per decimal(15,2)
,	@Take_Rate decimal(15,2)
,	@Family_Allocation decimal(15,2)

,	@Jan2015 decimal(10,2)
,	@Feb2015 decimal(10,2) 
,	@Mar2015 decimal(10,2) 
,	@Apr2015 decimal(10,2) 
,	@May2015 decimal(10,2) 
,	@Jun2015 decimal(10,2) 
,	@Jul2015 decimal(10,2) 
,	@Aug2015 decimal(10,2) 
,	@Sep2015 decimal(10,2) 
,	@Oct2015 decimal(10,2) 
,	@Nov2015 decimal(10,2) 
,	@Dec2015 decimal(10,2)
,	@Total_2015 decimal(10,2)
	 
,	@Jan2016 decimal(10,2) 
,	@Feb2016 decimal(10,2) 
,	@Mar2016 decimal(10,2) 
,	@Apr2016 decimal(10,2) 
,	@May2016 decimal(10,2) 
,	@Jun2016 decimal(10,2) 
,	@Jul2016 decimal(10,2) 
,	@Aug2016 decimal(10,2) 
,	@Sep2016 decimal(10,2) 
,	@Oct2016 decimal(10,2) 
,	@Nov2016 decimal(10,2) 
,	@Dec2016 decimal(10,2)
,	@Total_2016 decimal(10,2)

,	@Jan2017 decimal(10,2) 
,	@Feb2017 decimal(10,2) 
,	@Mar2017 decimal(10,2) 
,	@Apr2017 decimal(10,2) 
,	@May2017 decimal(10,2) 
,	@Jun2017 decimal(10,2) 
,	@Jul2017 decimal(10,2) 
,	@Aug2017 decimal(10,2) 
,	@Sep2017 decimal(10,2) 
,	@Oct2017 decimal(10,2) 
,	@Nov2017 decimal(10,2) 
,	@Dec2017 decimal(10,2)
,	@Total_2017 decimal(10,2) 

,	@Jan2018 decimal(10,2) 
,	@Feb2018 decimal(10,2) 
,	@Mar2018 decimal(10,2) 
,	@Apr2018 decimal(10,2) 
,	@May2018 decimal(10,2) 
,	@Jun2018 decimal(10,2) 
,	@Jul2018 decimal(10,2) 
,	@Aug2018 decimal(10,2) 
,	@Sep2018 decimal(10,2) 
,	@Oct2018 decimal(10,2) 
,	@Nov2018 decimal(10,2) 
,	@Dec2018 decimal(10,2)
,	@Total_2018 decimal(10,2)

,	@Jan2019 decimal(10,2) 
,	@Feb2019 decimal(10,2) 
,	@Mar2019 decimal(10,2) 
,	@Apr2019 decimal(10,2) 
,	@May2019 decimal(10,2) 
,	@Jun2019 decimal(10,2) 
,	@Jul2019 decimal(10,2) 
,	@Aug2019 decimal(10,2) 
,	@Sep2019 decimal(10,2) 
,	@Oct2019 decimal(10,2) 
,	@Nov2019 decimal(10,2) 
,	@Dec2019 decimal(10,2)
,	@Total_2019 decimal(10,2)
  
,	@Jan2020 decimal(10,2) 
,	@Feb2020 decimal(10,2) 
,	@Mar2020 decimal(10,2) 
,	@Apr2020 decimal(10,2) 
,	@May2020 decimal(10,2) 
,	@Jun2020 decimal(10,2) 
,	@Jul2020 decimal(10,2) 
,	@Aug2020 decimal(10,2) 
,	@Sep2020 decimal(10,2) 
,	@Oct2020 decimal(10,2) 
,	@Nov2020 decimal(10,2) 
,	@Dec2020 decimal(10,2)
,	@Total_2020 decimal(10,2) 

,	@Jan2021 decimal(10,2) 
,	@Feb2021 decimal(10,2) 
,	@Mar2021 decimal(10,2) 
,	@Apr2021 decimal(10,2) 
,	@May2021 decimal(10,2) 
,	@Jun2021 decimal(10,2) 
,	@Jul2021 decimal(10,2) 
,	@Aug2021 decimal(10,2) 
,	@Sep2021 decimal(10,2) 
,	@Oct2021 decimal(10,2) 
,	@Nov2021 decimal(10,2) 
,	@Dec2021 decimal(10,2)
,	@Total_2021 decimal(10,2) 

/*
,	@Jan2022 decimal(10,2) 
,	@Feb2022 decimal(10,2) 
,	@Mar2022 decimal(10,2) 
,	@Apr2022 decimal(10,2) 
,	@May2022 decimal(10,2) 
,	@Jun2022 decimal(10,2) 
,	@Jul2022 decimal(10,2) 
,	@Aug2022 decimal(10,2) 
,	@Sep2022 decimal(10,2) 
,	@Oct2022 decimal(10,2) 
,	@Nov2022 decimal(10,2) 
,	@Dec2022 decimal(10,2)
*/
   
,	@Total_2022 decimal(10,2)  
,	@Total_2023 decimal(10,2)
,	@Total_2024 decimal(10,2)
,	@Total_2025 decimal(10,2)
,	@Total_2026 decimal(10,2)

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
set @Version = 'Empire Adjustment'


-- Step 1: update header
select	
	[Platform] = @Platform
,	Program = @Program
,	Nameplate = @Vehicle
,	Plant = @Plant
,	SOP = @Sop
,	Eop = @Eop
,	*
from
	eeiuser.acctg_csm_NAIHS_header
where
	Release_ID = @Release_ID
	and [Mnemonic-Vehicle/Plant] = @MnemonicVehiclePlant
	and [Version] = @Version


-- Step 2: update detail
--- <Update rows>
select
	SalesDemand =
		case
			when EffectiveYear = 2015 and Period = 'M01' then @Jan2015
			when EffectiveYear = 2015 and Period = 'M02' then @Feb2015
			when EffectiveYear = 2015 and Period = 'M03' then @Mar2015
			when EffectiveYear = 2015 and Period = 'M04' then @Apr2015
			when EffectiveYear = 2015 and Period = 'M05' then @May2015
			when EffectiveYear = 2015 and Period = 'M06' then @Jun2015
			when EffectiveYear = 2015 and Period = 'M07' then @Jul2015
			when EffectiveYear = 2015 and Period = 'M08' then @Aug2015
			when EffectiveYear = 2015 and Period = 'M09' then @Sep2015
			when EffectiveYear = 2015 and Period = 'M10' then @Oct2015
			when EffectiveYear = 2015 and Period = 'M11' then @Nov2015
			when EffectiveYear = 2015 and Period = 'M12' then @Dec2015

			when EffectiveYear = 2016 and Period = 'M01' then @Jan2016
			when EffectiveYear = 2016 and Period = 'M02' then @Feb2016
			when EffectiveYear = 2016 and Period = 'M03' then @Mar2016
			when EffectiveYear = 2016 and Period = 'M04' then @Apr2016
			when EffectiveYear = 2016 and Period = 'M05' then @May2016
			when EffectiveYear = 2016 and Period = 'M06' then @Jun2016
			when EffectiveYear = 2016 and Period = 'M07' then @Jul2016
			when EffectiveYear = 2016 and Period = 'M08' then @Aug2016
			when EffectiveYear = 2016 and Period = 'M09' then @Sep2016
			when EffectiveYear = 2016 and Period = 'M10' then @Oct2016
			when EffectiveYear = 2016 and Period = 'M11' then @Nov2016
			when EffectiveYear = 2016 and Period = 'M12' then @Dec2016

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

			-- Quarters
			when EffectiveYear = 2015 and Period = 'Q1' then (@Jan2015 + @Feb2015 + @Mar2015)
			when EffectiveYear = 2015 and Period = 'Q2' then (@Apr2015 + @May2015 + @Jun2015)
			when EffectiveYear = 2015 and Period = 'Q3' then (@Jul2015 + @Aug2015 + @Sep2015)
			when EffectiveYear = 2015 and Period = 'Q4' then (@Oct2015 + @Nov2015 + @Dec2015)

			when EffectiveYear = 2016 and Period = 'Q1' then (@Jan2016 + @Feb2016 + @Mar2016)
			when EffectiveYear = 2016 and Period = 'Q2' then (@Apr2016 + @May2016 + @Jun2016)
			when EffectiveYear = 2016 and Period = 'Q3' then (@Jul2016 + @Aug2016 + @Sep2016)
			when EffectiveYear = 2016 and Period = 'Q4' then (@Oct2016 + @Nov2016 + @Dec2016)

			when EffectiveYear = 2017 and Period = 'Q1' then (@Jan2017 + @Feb2017 + @Mar2017)
			when EffectiveYear = 2017 and Period = 'Q2' then (@Apr2017 + @May2017 + @Jun2017)
			when EffectiveYear = 2017 and Period = 'Q3' then (@Jul2017 + @Aug2017 + @Sep2017)
			when EffectiveYear = 2017 and Period = 'Q4' then (@Oct2017 + @Nov2017 + @Dec2017)
			
			when EffectiveYear = 2018 and Period = 'Q1' then (@Jan2018 + @Feb2018 + @Mar2018)
			when EffectiveYear = 2018 and Period = 'Q2' then (@Apr2018 + @May2018 + @Jun2018)
			when EffectiveYear = 2018 and Period = 'Q3' then (@Jul2018 + @Aug2018 + @Sep2018)
			when EffectiveYear = 2018 and Period = 'Q4' then (@Oct2018 + @Nov2018 + @Dec2018)

			when EffectiveYear = 2019 and Period = 'Q1' then (@Jan2019 + @Feb2019 + @Mar2019)
			when EffectiveYear = 2019 and Period = 'Q2' then (@Apr2019 + @May2019 + @Jun2019)
			when EffectiveYear = 2019 and Period = 'Q3' then (@Jul2019 + @Aug2019 + @Sep2019)
			when EffectiveYear = 2019 and Period = 'Q4' then (@Oct2019 + @Nov2019 + @Dec2019)

			when EffectiveYear = 2020 and Period = 'Q1' then (@Jan2020 + @Feb2020 + @Mar2020)
			when EffectiveYear = 2020 and Period = 'Q2' then (@Apr2020 + @May2020 + @Jun2020)
			when EffectiveYear = 2020 and Period = 'Q3' then (@Jul2020 + @Aug2020 + @Sep2020)
			when EffectiveYear = 2020 and Period = 'Q4' then (@Oct2020 + @Nov2020 + @Dec2020)

			when EffectiveYear = 2021 and Period = 'Q1' then (@Jan2021 + @Feb2021 + @Mar2021)
			when EffectiveYear = 2021 and Period = 'Q2' then (@Apr2021 + @May2021 + @Jun2021)
			when EffectiveYear = 2021 and Period = 'Q3' then (@Jul2021 + @Aug2021 + @Sep2021)
			when EffectiveYear = 2021 and Period = 'Q4' then (@Oct2021 + @Nov2021 + @Dec2021)

			when EffectiveYear = 2022 and Period in ('Q1', 'Q2', 'Q3', 'Q4') then (round(@Total_2022 / 4, 0))
			when EffectiveYear = 2023 and Period in ('Q1', 'Q2', 'Q3', 'Q4') then (round(@Total_2023 / 4, 0))
			when EffectiveYear = 2024 and Period in ('Q1', 'Q2', 'Q3', 'Q4') then (round(@Total_2024 / 4, 0))
			when EffectiveYear = 2025 and Period in ('Q1', 'Q2', 'Q3', 'Q4') then (round(@Total_2025 / 4, 0))
			when EffectiveYear = 2026 and Period in ('Q1', 'Q2', 'Q3', 'Q4') then (round(@Total_2026 / 4, 0))
			
			-- Calculated Years
			when EffectiveYear = 2015 and Period = 'CY' then (@Jan2015 + @Feb2015 + @Mar2015 + @Apr2015 + @May2015 + @Jun2015 + @Jul2015 + @Aug2015 + @Sep2015 + @Oct2015 + @Nov2015 + @Dec2015)
			when EffectiveYear = 2016 and Period = 'CY' then (@Jan2016 + @Feb2016 + @Mar2016 + @Apr2016 + @May2016 + @Jun2016 + @Jul2016 + @Aug2016 + @Sep2016 + @Oct2016 + @Nov2016 + @Dec2016)
			when EffectiveYear = 2017 and Period = 'CY' then (@Jan2017 + @Feb2017 + @Mar2017 + @Apr2017 + @May2017 + @Jun2017 + @Jul2017 + @Aug2017 + @Sep2017 + @Oct2017 + @Nov2017 + @Dec2017)
			when EffectiveYear = 2018 and Period = 'CY' then (@Jan2018 + @Feb2018 + @Mar2018 + @Apr2018 + @May2018 + @Jun2018 + @Jul2018 + @Aug2018 + @Sep2018 + @Oct2018 + @Nov2018 + @Dec2018)
			when EffectiveYear = 2019 and Period = 'CY' then (@Jan2019 + @Feb2019 + @Mar2019 + @Apr2019 + @May2019 + @Jun2019 + @Jul2019 + @Aug2019 + @Sep2019 + @Oct2019 + @Nov2019 + @Dec2019)
			when EffectiveYear = 2020 and Period = 'CY' then (@Jan2020 + @Feb2020 + @Mar2020 + @Apr2020 + @May2020 + @Jun2020 + @Jul2020 + @Aug2020 + @Sep2020 + @Oct2020 + @Nov2020 + @Dec2020)
			when EffectiveYear = 2021 and Period = 'CY' then (@Jan2021 + @Feb2021 + @Mar2021 + @Apr2021 + @May2021 + @Jun2021 + @Jul2021 + @Aug2021 + @Sep2021 + @Oct2021 + @Nov2021 + @Dec2021)
		
			when EffectiveYear = 2022 and Period = 'CY' then isnull(@Total_2022, 0)
			when EffectiveYear = 2023 and Period = 'CY' then isnull(@Total_2023, 0)
			when EffectiveYear = 2024 and Period = 'CY' then isnull(@Total_2024, 0)
			when EffectiveYear = 2025 and Period = 'CY' then isnull(@Total_2025, 0)
			when EffectiveYear = 2026 and Period = 'CY' then isnull(@Total_2026, 0)
		end
,	*
from
	eeiuser.acctg_csm_naihs_detail
where
	Release_ID = @Release_ID
	and [Mnemonic-Vehicle/Plant] = @MnemonicVehiclePlant
	and [Version] = @Version
	and EffectiveYear >= 2015
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
