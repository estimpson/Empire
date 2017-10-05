SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_WP_UpdateCsmDemand_EmpireFactor_History] 
	@BasePart varchar(30),
	@Version varchar(30),
	@ReleaseID varchar(10),
	@MnemonicVehiclePlant varchar(30),  
	@TakeRate decimal(10,2),
	@QtyPer decimal(10,2),
	@FamilyAllocation decimal(10,2),

	@Jan2015 decimal(15,2), 
	@Feb2015 decimal(15,2), 
	@Mar2015 decimal(15,2), 
	@Apr2015 decimal(15,2), 
	@May2015 decimal(15,2), 
	@Jun2015 decimal(15,2), 
	@Jul2015 decimal(15,2), 
	@Aug2015 decimal(15,2), 
	@Sep2015 decimal(15,2), 
	@Oct2015 decimal(15,2), 
	@Nov2015 decimal(15,2), 
	@Dec2015 decimal(15,2),
	@Total_2015 decimal(15,2),
	  
	@Jan2016 decimal(16,2), 
	@Feb2016 decimal(16,2), 
	@Mar2016 decimal(16,2), 
	@Apr2016 decimal(16,2), 
	@May2016 decimal(16,2), 
	@Jun2016 decimal(16,2), 
	@Jul2016 decimal(16,2), 
	@Aug2016 decimal(16,2), 
	@Sep2016 decimal(16,2), 
	@Oct2016 decimal(16,2), 
	@Nov2016 decimal(16,2), 
	@Dec2016 decimal(16,2),
	@Total_2016 decimal(16,2), 

	@Jan2017 decimal(16,2), 
	@Feb2017 decimal(16,2), 
	@Mar2017 decimal(16,2), 
	@Apr2017 decimal(16,2), 
	@May2017 decimal(16,2), 
	@Jun2017 decimal(16,2), 
	@Jul2017 decimal(16,2), 
	@Aug2017 decimal(16,2), 
	@Sep2017 decimal(16,2), 
	@Oct2017 decimal(16,2), 
	@Nov2017 decimal(16,2), 
	@Dec2017 decimal(16,2),
	@Total_2017 decimal(16,2), 

	@Jan2018 decimal(16,2), 
	@Feb2018 decimal(16,2), 
	@Mar2018 decimal(16,2), 
	@Apr2018 decimal(16,2), 
	@May2018 decimal(16,2), 
	@Jun2018 decimal(16,2), 
	@Jul2018 decimal(16,2), 
	@Aug2018 decimal(16,2), 
	@Sep2018 decimal(16,2), 
	@Oct2018 decimal(16,2), 
	@Nov2018 decimal(16,2), 
	@Dec2018 decimal(16,2),
	@Total_2018 decimal(16,2), 
     
	@Jan2019 decimal(16,2), 
	@Feb2019 decimal(16,2), 
	@Mar2019 decimal(16,2), 
	@Apr2019 decimal(16,2), 
	@May2019 decimal(16,2), 
	@Jun2019 decimal(16,2), 
	@Jul2019 decimal(16,2), 
	@Aug2019 decimal(16,2), 
	@Sep2019 decimal(16,2), 
	@Oct2019 decimal(16,2), 
	@Nov2019 decimal(16,2), 
	@Dec2019 decimal(16,2),
	@Total_2019 decimal(16,2), 
     
	/*
	@Jan2020 decimal(16,2), 
	@Feb2020 decimal(16,2), 
	@Mar2020 decimal(16,2), 
	@Apr2020 decimal(16,2), 
	@May2020 decimal(16,2), 
	@Jun2020 decimal(16,2), 
	@Jul2020 decimal(16,2), 
	@Aug2020 decimal(16,2), 
	@Sep2020 decimal(16,2), 
	@Oct2020 decimal(16,2), 
	@Nov2020 decimal(16,2), 
	@Dec2020 decimal(16,2),
	*/
     
	@Total_2020 decimal(16,2), 
	@Total_2021 decimal(15,2),
	@Total_2022 decimal(15,2)  

,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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

---	</ArgumentValidation>


--- <Body>
--- <Insert rows="1+">
set	@TableName = 'EEIUser.WP_SalesForecast_EmpireFactor_History'

insert into
	EEIUser.WP_SalesForecast_EmpireFactor_History
(
	BasePart
,	[Version]
,	ReleaseID
,	MnemonicVehiclePlant 
,	TakeRate
,	[Platform] 
,	Program
,	Vehicle
,	Plant 
,	SOP 
,	EOP 
,	QtyPer
,	FamilyAllocation
,	EmpireMarketSegment
,	EmpireApplication
,	DateStamp
,	Jan2015
,	Feb2015
,	Mar2015
,	Apr2015
,	May2015
,	Jun2015
,	Jul2015
,	Aug2015
,	Sep2015
,	Oct2015
,	Nov2015
,	Dec2015
,	Total2015
,	Jan2016
,	Feb2016
,	Mar2016
,	Apr2016
,	May2016
,	Jun2016
,	Jul2016
,	Aug2016
,	Sep2016
,	Oct2016
,	Nov2016
,	Dec2016
,	Total2016
,	Jan2017
,	Feb2017
,	Mar2017
,	Apr2017
,	May2017
,	Jun2017
,	Jul2017
,	Aug2017
,	Sep2017
,	Oct2017
,	Nov2017
,	Dec2017
,	Total2017
,	Jan2018
,	Feb2018
,	Mar2018
,	Apr2018
,	May2018
,	Jun2018
,	Jul2018
,	Aug2018
,	Sep2018
,	Oct2018
,	Nov2018
,	Dec2018
,	Total2018
,	Jan2019
,	Feb2019
,	Mar2019
,	Apr2019
,	May2019
,	Jun2019
,	Jul2019
,	Aug2019
,	Sep2019
,	Oct2019
,	Nov2019
,	Dec2019
,	Total2019
,	Total2020
,	Total2021
,	Total2022

,	Jan2015New
,	Feb2015New
,	Mar2015New
,	Apr2015New
,	May2015New
,	Jun2015New
,	Jul2015New
,	Aug2015New
,	Sep2015New
,	Oct2015New
,	Nov2015New
,	Dec2015New
,	Total2015New
,	Jan2016New
,	Feb2016New
,	Mar2016New
,	Apr2016New
,	May2016New
,	Jun2016New
,	Jul2016New
,	Aug2016New
,	Sep2016New
,	Oct2016New
,	Nov2016New
,	Dec2016New
,	Total2016New
,	Jan2017New
,	Feb2017New
,	Mar2017New
,	Apr2017New
,	May2017New
,	Jun2017New
,	Jul2017New
,	Aug2017New
,	Sep2017New
,	Oct2017New
,	Nov2017New
,	Dec2017New
,	Total2017New
,	Jan2018New
,	Feb2018New
,	Mar2018New
,	Apr2018New
,	May2018New
,	Jun2018New
,	Jul2018New
,	Aug2018New
,	Sep2018New
,	Oct2018New
,	Nov2018New
,	Dec2018New
,	Total2018New
,	Jan2019New
,	Feb2019New
,	Mar2019New
,	Apr2019New
,	May2019New
,	Jun2019New
,	Jul2019New
,	Aug2019New
,	Sep2019New
,	Oct2019New
,	Nov2019New
,	Dec2019New
,	Total2019New
,	Total2020New
,	Total2021New
,	Total2022New
)
select	
	@BasePart,
	b.version,
	b.release_id, 
	b.[Mnemonic-Vehicle/Plant], 
	isnull(a.take_rate,0), 
	b.platform, 
	b.program, 
	b.brand + ' ' + b.[nameplate], 
	b.plant, 
	b.[sop], 
	b.[eop],
	isnull(a.qty_per,0),
	isnull(a.family_allocation,0),
	a.empire_market_segment,
	a.empire_application,
	@TranDT,

    ISNULL(b.[jan 2015],0), 
	ISNULL(b.[feb 2015],0), 
	ISNULL(b.[mar 2015],0), 
	ISNULL(b.[apr 2015],0), 
	ISNULL(b.[may 2015],0), 
	ISNULL(b.[jun 2015],0), 
	ISNULL(b.[jul 2015],0), 
	ISNULL(b.[aug 2015],0), 
	ISNULL(b.[sep 2015],0), 
	ISNULL(b.[oct 2015],0), 
	ISNULL(b.[nov 2015],0), 
	ISNULL(b.[dec 2015],0), 
	(ISNULL(b.[jan 2015],0)+ISNULL(b.[feb 2015],0)+ISNULL(b.[mar 2015],0)+ISNULL(b.[apr 2015],0)+ISNULL(b.[may 2015],0)+ISNULL(b.[jun 2015],0)+ISNULL(b.[jul 2015],0)+ISNULL(b.[aug 2015],0)+ISNULL(b.[sep 2015],0)+ISNULL(b.[oct 2015],0)+ISNULL(b.[nov 2015],0)+ISNULL(b.[dec 2015],0)),

	ISNULL(b.[jan 2016],0), 
	ISNULL(b.[feb 2016],0), 
	ISNULL(b.[mar 2016],0), 
	ISNULL(b.[apr 2016],0), 
	ISNULL(b.[may 2016],0), 
	ISNULL(b.[jun 2016],0), 
	ISNULL(b.[jul 2016],0), 
	ISNULL(b.[aug 2016],0), 
	ISNULL(b.[sep 2016],0), 
	ISNULL(b.[oct 2016],0), 
	ISNULL(b.[nov 2016],0), 
	ISNULL(b.[dec 2016],0), 
	(ISNULL(b.[jan 2016],0)+ISNULL(b.[feb 2016],0)+ISNULL(b.[mar 2016],0)+ISNULL(b.[apr 2016],0)+ISNULL(b.[may 2016],0)+ISNULL(b.[jun 2016],0)+ISNULL(b.[jul 2016],0)+ISNULL(b.[aug 2016],0)+ISNULL(b.[sep 2016],0)+ISNULL(b.[oct 2016],0)+ISNULL(b.[nov 2016],0)+ISNULL(b.[dec 2016],0)),

	ISNULL(b.[jan 2017],0), 
	ISNULL(b.[feb 2017],0), 
	ISNULL(b.[mar 2017],0), 
	ISNULL(b.[apr 2017],0), 
	ISNULL(b.[may 2017],0), 
	ISNULL(b.[jun 2017],0), 
	ISNULL(b.[jul 2017],0), 
	ISNULL(b.[aug 2017],0), 
	ISNULL(b.[sep 2017],0), 
	ISNULL(b.[oct 2017],0), 
	ISNULL(b.[nov 2017],0), 
	ISNULL(b.[dec 2017],0), 
	(ISNULL(b.[jan 2017],0)+ISNULL(b.[feb 2017],0)+ISNULL(b.[mar 2017],0)+ISNULL(b.[apr 2017],0)+ISNULL(b.[may 2017],0)+ISNULL(b.[jun 2017],0)+ISNULL(b.[jul 2017],0)+ISNULL(b.[aug 2017],0)+ISNULL(b.[sep 2017],0)+ISNULL(b.[oct 2017],0)+ISNULL(b.[nov 2017],0)+ISNULL(b.[dec 2017],0)),
		 
	ISNULL(b.[jan 2018],0), 
	ISNULL(b.[feb 2018],0), 
	ISNULL(b.[mar 2018],0), 
	ISNULL(b.[apr 2018],0), 
	ISNULL(b.[may 2018],0), 
	ISNULL(b.[jun 2018],0), 
	ISNULL(b.[jul 2018],0), 
	ISNULL(b.[aug 2018],0), 
	ISNULL(b.[sep 2018],0), 
	ISNULL(b.[oct 2018],0), 
	ISNULL(b.[nov 2018],0), 
	ISNULL(b.[dec 2018],0), 
	(ISNULL(b.[jan 2018],0)+ISNULL(b.[feb 2018],0)+ISNULL(b.[mar 2018],0)+ISNULL(b.[apr 2018],0)+ISNULL(b.[may 2018],0)+ISNULL(b.[jun 2018],0)+ISNULL(b.[jul 2018],0)+ISNULL(b.[aug 2018],0)+ISNULL(b.[sep 2018],0)+ISNULL(b.[oct 2018],0)+ISNULL(b.[nov 2018],0)+ISNULL(b.[dec 2018],0)),
		
	ISNULL(b.[jan 2019],0), 
	ISNULL(b.[feb 2019],0), 
	ISNULL(b.[mar 2019],0), 
	ISNULL(b.[apr 2019],0), 
	ISNULL(b.[may 2019],0), 
	ISNULL(b.[jun 2019],0), 
	ISNULL(b.[jul 2019],0), 
	ISNULL(b.[aug 2019],0), 
	ISNULL(b.[sep 2019],0), 
	ISNULL(b.[oct 2019],0), 
	ISNULL(b.[nov 2019],0), 
	ISNULL(b.[dec 2019],0), 
	(ISNULL(b.[jan 2019],0)+ISNULL(b.[feb 2019],0)+ISNULL(b.[mar 2019],0)+ISNULL(b.[apr 2019],0)+ISNULL(b.[may 2019],0)+ISNULL(b.[jun 2019],0)+ISNULL(b.[jul 2019],0)+ISNULL(b.[aug 2019],0)+ISNULL(b.[sep 2019],0)+ISNULL(b.[oct 2019],0)+ISNULL(b.[nov 2019],0)+ISNULL(b.[dec 2019],0)),
		
	/*
	ISNULL(b.[jan 2020],0), 
	ISNULL(b.[feb 2020],0), 
	ISNULL(b.[mar 2020],0), 
	ISNULL(b.[apr 2020],0), 
	ISNULL(b.[may 2020],0), 
	ISNULL(b.[jun 2020],0), 
	ISNULL(b.[jul 2020],0), 
	ISNULL(b.[aug 2020],0), 
	ISNULL(b.[sep 2020],0), 
	ISNULL(b.[oct 2020],0), 
	ISNULL(b.[nov 2020],0), 
	ISNULL(b.[dec 2020],0), 
	(ISNULL(b.[jan 2020],0)+ISNULL(b.[feb 2020],0)+ISNULL(b.[mar 2020],0)+ISNULL(b.[apr 2020],0)+ISNULL(b.[may 2020],0)+ISNULL(b.[jun 2020],0)+ISNULL(b.[jul 2020],0)+ISNULL(b.[aug 2020],0)+ISNULL(b.[sep 2020],0)+ISNULL(b.[oct 2020],0)+ISNULL(b.[nov 2020],0)+ISNULL(b.[dec 2020],0)),
	*/
		
	ISNULL(b.[CY 2020] ,0), 
	ISNULL(b.[CY 2021] ,0), 
	ISNULL(b.[CY 2022] ,0),

	@Jan2015, 
	@Feb2015, 
	@Mar2015, 
	@Apr2015, 
	@May2015, 
	@Jun2015, 
	@Jul2015, 
	@Aug2015, 
	@Sep2015, 
	@Oct2015, 
	@Nov2015, 
	@Dec2015,
	@Total_2015,
	  
	@Jan2016, 
	@Feb2016, 
	@Mar2016, 
	@Apr2016, 
	@May2016, 
	@Jun2016, 
	@Jul2016, 
	@Aug2016, 
	@Sep2016, 
	@Oct2016, 
	@Nov2016, 
	@Dec2016,
	@Total_2016, 

	@Jan2017, 
	@Feb2017, 
	@Mar2017, 
	@Apr2017, 
	@May2017, 
	@Jun2017, 
	@Jul2017, 
	@Aug2017, 
	@Sep2017, 
	@Oct2017, 
	@Nov2017, 
	@Dec2017,
	@Total_2017, 

	@Jan2018, 
	@Feb2018, 
	@Mar2018, 
	@Apr2018, 
	@May2018, 
	@Jun2018, 
	@Jul2018, 
	@Aug2018, 
	@Sep2018, 
	@Oct2018, 
	@Nov2018, 
	@Dec2018,
	@Total_2018, 
     
	@Jan2019, 
	@Feb2019, 
	@Mar2019, 
	@Apr2019, 
	@May2019, 
	@Jun2019, 
	@Jul2019, 
	@Aug2019, 
	@Sep2019, 
	@Oct2019, 
	@Nov2019, 
	@Dec2019,
	@Total_2019, 
     
	/*
	@Jan2020, 
	@Feb2020, 
	@Mar2020, 
	@Apr2020, 
	@May2020, 
	@Jun2020, 
	@Jul2020, 
	@Aug2020, 
	@Sep2020, 
	@Oct2020, 
	@Nov2020, 
	@Dec2020,
	*/
     
	@Total_2020, 
	@Total_2021,
	@Total_2022
from 
	(	select	* 
		from	eeiuser.acctg_csm_base_part_mnemonic
	) a 
	left outer join 
	(	select	* 
		from	eeiuser.acctg_csm_NAIHS 
		where	release_id = @ReleaseID
	) b
	on b.[Mnemonic-Vehicle/Plant] = a.mnemonic
	where	a.base_part = @BasePart
		and b.[Mnemonic-Vehicle/Plant] is not null
		and b.VERSION = 'Empire Factor'


select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999998
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
--- </Body>


--- <Tran AutoClose=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </Tran>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
