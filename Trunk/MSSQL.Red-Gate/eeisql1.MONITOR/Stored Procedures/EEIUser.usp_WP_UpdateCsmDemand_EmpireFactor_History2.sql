SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_WP_UpdateCsmDemand_EmpireFactor_History2] 
	@BasePart varchar(30)
,	@ReleaseID varchar(10)
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
	ISNULL(b.[CY 2022] ,0)
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
	--RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	--RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
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
