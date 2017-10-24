SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [dbo].[eeisp_GM_CSMAssociation_April09_July09EEIQty]
as

Begin

Declare		@Date1 datetime,
			@Date2 datetime
Select		@date1 = getdate()
Select		@date2 = dateadd(wk, 26, @date1)


Select	Sales_parent,
		Assembly_plant,		
		Base_part,
		Program,
		Badge+' '+NamePlate as Vehicle,
		qty_per,
		take_rate,
		family_allocation,
		Max(eeiQty) as EEIQty,
		EEIDueWeek as EEIDueWeek
from		
	

(select * from eeiuser.acctg_csm_base_part_mnemonic) a 
join 
(select * from eeiuser.acctg_csm_NACSM where release_id = '2009-03') b on a.mnemonic = b.mnemonic
cross join (select		ft.fn_truncdate('wk',EntryDT) DueDT
		from			[FT].[fn_Calendar] (@date1,@date2,'wk', 1,26)
		where		EntryDT >=@date1) Buckets
left	join ( Select	sum(eeiqty) as EEIQty,
				left(part_number,7) as BAsePart,
				ft.fn_truncdate('wk', due_date) as EEIDueWeek
				From	order_detail
				group by left(part_number,7),
						ft.fn_truncdate('wk', due_date))  EEIDemand on Base_part = EEIDemand.BasePart and Buckets.DueDT = EEIDemand.EEIDueWeek

where	version = 'CSM' and
Sales_parent = 'General Motors'
group by Sales_parent,
		Assembly_plant,		
		Base_part,
		Program,
		(Badge+' '+NamePlate),
		qty_per,
		take_rate,
		family_allocation,
		EEIDueWeek
order by 3,10
End
GO
