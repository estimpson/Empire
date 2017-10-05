SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_UpdateCsmDemand_TakeRate_History] 
	@BasePart varchar(30)
,	@ReleaseID varchar(10)
,	@MnemonicVehiclePlant varchar(30)
,	@QtyPer decimal(10,2)
,	@TakeRate decimal(10,2)
,	@FamilyAllocation decimal(10,2)
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
set	@TableName = 'EEIUser.WP_SalesForecastTakeRate_History'

insert into
	EEIUser.WP_SalesForecastTakeRate_History
(
	BasePart
,	[Version]
,	ReleaseID
,	MnemonicVehiclePlant 
,	TakeRate
,	TakeRateNew
,	[Platform] 
,	Program
,	Vehicle
,	Plant 
,	SOP 
,	EOP 
,	QtyPer
,	QtyPerNew
,	FamilyAllocation
,	FamilyAllocationNew
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
	@BasePart
,	b.version
,	b.release_id 
,	b.[Mnemonic-Vehicle/Plant]
,	isnull (a.take_rate, 0) 
,	@TakeRate
,	b.platform 
,	b.program 
,	b.brand + ' ' + b.nameplate
,	b.plant 
,	b.sop
,	b.eop  
,	isnull(a.qty_per, 0)
,	@QtyPer
,	isnull(a.family_allocation, 0)
,	@FamilyAllocation
,	a.empire_market_segment
,	a.empire_application
,	@TranDT

,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2015] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2015] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2015],0)+ISNULL(b.[Feb 2015],0)+ISNULL(b.[Mar 2015],0)+ISNULL(b.[Apr 2015],0)+ISNULL(b.[May 2015],0)+ISNULL(b.[Jun 2015],0)+ISNULL(b.[Jul 2015],0)+ISNULL(b.[Aug 2015],0)+ISNULL(b.[Sep 2015],0)+ISNULL(b.[Oct 2015],0)+ISNULL(b.[Nov 2015],0)+ISNULL(b.[Dec 2015],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]) end),0)
		
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2016] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2016] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2016],0)+ISNULL(b.[Feb 2016],0)+ISNULL(b.[Mar 2016],0)+ISNULL(b.[Apr 2016],0)+ISNULL(b.[May 2016],0)+ISNULL(b.[Jun 2016],0)+ISNULL(b.[Jul 2016],0)+ISNULL(b.[Aug 2016],0)+ISNULL(b.[Sep 2016],0)+ISNULL(b.[Oct 2016],0)+ISNULL(b.[Nov 2016],0)+ISNULL(b.[Dec 2016],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2016]+b.[Feb 2016]+b.[Mar 2016]+b.[Apr 2016]+b.[May 2016]+b.[Jun 2016]+b.[Jul 2016]+b.[Aug 2016]+b.[Sep 2016]+b.[Oct 2016]+b.[Nov 2016]+b.[Dec 2016]) end),0)

,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2017] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2017] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2017] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2017],0)+ISNULL(b.[Feb 2017],0)+ISNULL(b.[Mar 2017],0)+ISNULL(b.[Apr 2017],0)+ISNULL(b.[May 2017],0)+ISNULL(b.[Jun 2017],0)+ISNULL(b.[Jul 2017],0)+ISNULL(b.[Aug 2017],0)+ISNULL(b.[Sep 2017],0)+ISNULL(b.[Oct 2017],0)+ISNULL(b.[Nov 2017],0)+ISNULL(b.[Dec 2017],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2017]+b.[Feb 2017]+b.[Mar 2017]+b.[Apr 2017]+b.[May 2017]+b.[Jun 2017]+b.[Jul 2017]+b.[Aug 2017]+b.[Sep 2017]+b.[Oct 2017]+b.[Nov 2017]+b.[Dec 2017]) end),0)

,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2018] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2018] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2018] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2018] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2018] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2018],0)+ISNULL(b.[Feb 2018],0)+ISNULL(b.[Mar 2018],0)+ISNULL(b.[Apr 2018],0)+ISNULL(b.[May 2018],0)+ISNULL(b.[Jun 2018],0)+ISNULL(b.[Jul 2018],0)+ISNULL(b.[Aug 2018],0)+ISNULL(b.[Sep 2018],0)+ISNULL(b.[Oct 2018],0)+ISNULL(b.[Nov 2018],0)+ISNULL(b.[Dec 2018],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2018]+b.[Feb 2018]+b.[Mar 2018]+b.[Apr 2018]+b.[May 2018]+b.[Jun 2018]+b.[Jul 2018]+b.[Aug 2018]+b.[Sep 2018]+b.[Oct 2018]+b.[Nov 2018]+b.[Dec 2018]) end),0)

,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2019] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2019] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2019] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2019] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2019],0)+ISNULL(b.[Feb 2019],0)+ISNULL(b.[Mar 2019],0)+ISNULL(b.[Apr 2019],0)+ISNULL(b.[May 2019],0)+ISNULL(b.[Jun 2019],0)+ISNULL(b.[Jul 2019],0)+ISNULL(b.[Aug 2019],0)+ISNULL(b.[Sep 2019],0)+ISNULL(b.[Oct 2019],0)+ISNULL(b.[Nov 2019],0)+ISNULL(b.[Dec 2019],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2019]+b.[Feb 2019]+b.[Mar 2019]+b.[Apr 2019]+b.[May 2019]+b.[Jun 2019]+b.[Jul 2019]+b.[Aug 2019]+b.[Sep 2019]+b.[Oct 2019]+b.[Nov 2019]+b.[Dec 2019]) end),0)
		
	/*
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2020] end),0) 
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2020],0)+ISNULL(b.[Feb 2020],0)+ISNULL(b.[Mar 2020],0)+ISNULL(b.[Apr 2020],0)+ISNULL(b.[May 2020],0)+ISNULL(b.[Jun 2020],0)+ISNULL(b.[Jul 2020],0)+ISNULL(b.[Aug 2020],0)+ISNULL(b.[Sep 2020],0)+ISNULL(b.[Oct 2020],0)+ISNULL(b.[Nov 2020],0)+ISNULL(b.[Dec 2020],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2020]+b.[Feb 2020]+b.[Mar 2020]+b.[Apr 2020]+b.[May 2020]+b.[Jun 2020]+b.[Jul 2020]+b.[Aug 2020]+b.[Sep 2020]+b.[Oct 2020]+b.[Nov 2020]+b.[Dec 2020]) end),0)
	*/
		
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2020] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2021],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2021] end),0)
,	ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2022],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2022] end),0)
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
		and b.Version = 'CSM'
		--and (case	when b.version='Empire' 
		--			then ( ISNULL(b.[Jan 2012],0)+ISNULL(b.[Feb 2012],0)+ISNULL(b.[Mar 2012],0)+ISNULL(b.[Apr 2012],0)+ISNULL(b.[May 2012],0)+ISNULL(b.[Jun 2012],0)+ISNULL(b.[Jul 2012],0)+ISNULL(b.[Aug 2012],0)+ISNULL(b.[Sep 2012],0)+ISNULL(b.[Oct 2012],0)+ISNULL(b.[Nov 2012],0)+ISNULL(b.[Dec 2012],0)
		--		   		  +ISNULL(b.[Jan 2014],0)+ISNULL(b.[Feb 2014],0)+ISNULL(b.[Mar 2014],0)+ISNULL(b.[Apr 2014],0)+ISNULL(b.[May 2014],0)+ISNULL(b.[Jun 2014],0)+ISNULL(b.[Jul 2014],0)+ISNULL(b.[Aug 2014],0)+ISNULL(b.[Sep 2014],0)+ISNULL(b.[Oct 2014],0)+ISNULL(b.[Nov 2014],0)+ISNULL(b.[Dec 2014],0)
		--				  +ISNULL(b.[Jan 2015],0)+ISNULL(b.[Feb 2015],0)+ISNULL(b.[Mar 2015],0)+ISNULL(b.[Apr 2015],0)+ISNULL(b.[May 2015],0)+ISNULL(b.[Jun 2015],0)+ISNULL(b.[Jul 2015],0)+ISNULL(b.[Aug 2015],0)+ISNULL(b.[Sep 2015],0)+ISNULL(b.[Oct 2015],0)+ISNULL(b.[Nov 2015],0)+ISNULL(b.[Dec 2015],0)
		--				  +ISNULL(b.[Jan 2011],0)+ISNULL(b.[Feb 2011],0)+ISNULL(b.[Mar 2011],0)+ISNULL(b.[Apr 2011],0)+ISNULL(b.[May 2011],0)+ISNULL(b.[Jun 2011],0)+ISNULL(b.[Jul 2011],0)+ISNULL(b.[Aug 2011],0)+ISNULL(b.[Sep 2011],0)+ISNULL(b.[Oct 2011],0)+ISNULL(b.[Nov 2011],0)+ISNULL(b.[Dec 2011],0)
		--				  +ISNULL(b.[Jan 2012],0)+ISNULL(b.[Feb 2012],0)+ISNULL(b.[Mar 2012],0)+ISNULL(b.[Apr 2012],0)+ISNULL(b.[May 2012],0)+ISNULL(b.[Jun 2012],0)+ISNULL(b.[Jul 2012],0)+ISNULL(b.[Aug 2012],0)+ISNULL(b.[Sep 2012],0)+ISNULL(b.[Oct 2012],0)+ISNULL(b.[Nov 2012],0)+ISNULL(b.[Dec 2012],0)
		--		  	      ) 
		--		  	else  a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2012]+b.[Feb 2012]+b.[Mar 2012]+b.[Apr 2012]+b.[May 2012]+b.[Jun 2012]+b.[Jul 2012]+b.[Aug 2012]+b.[Sep 2012]+b.[Oct 2012]+b.[Nov 2012]+b.[Dec 2012]
		--		  													+b.[Jan 2014]+b.[Feb 2014]+b.[Mar 2014]+b.[Apr 2014]+b.[May 2014]+b.[Jun 2014]+b.[Jul 2014]+b.[Aug 2014]+b.[Sep 2014]+b.[Oct 2014]+b.[Nov 2014]+b.[Dec 2014]
		--		  													+b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]
		--		  													+b.[Jan 2011]+b.[Feb 2011]+b.[Mar 2011]+b.[Apr 2011]+b.[May 2011]+b.[Jun 2011]+b.[Jul 2011]+b.[Aug 2011]+b.[Sep 2011]+b.[Oct 2011]+b.[Nov 2011]+b.[Dec 2011]
		--		  													+b.[Jan 2012]+b.[Feb 2012]+b.[Mar 2012]+b.[Apr 2012]+b.[May 2012]+b.[Jun 2012]+b.[Jul 2012]+b.[Aug 2012]+b.[Sep 2012]+b.[Oct 2012]+b.[Nov 2012]+b.[Dec 2012]		
		--		  													) 
		--			end
		--	) <> -.00003
			-- (case @checkbox1 when 0 then 0 else -.0003 end) 

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
