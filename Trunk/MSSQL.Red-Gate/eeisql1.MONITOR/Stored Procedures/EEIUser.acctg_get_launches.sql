SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE proc [EEIUser].[acctg_get_launches] @bill_customer varchar(20)--, @selection_beg_date datetime, @selection_end_date datetime) 
as

select		a.base_part+' Launch' as base_part
			,min(isnull(empire_sop,sop)) as sop
			,(case when min(ISNULL(empire_sop,NULL)) != NULL then 'Warning: the Empire SOP of '+min(empire_sop)+' is different than the CSM SOP of '+min(sop) else '' end) as flag
			,max(isnull(empire_eop,eop)) as eop
from		eeiuser.acctg_csm_base_part_mnemonic a 
  left join eeiuser.acctg_csm_nacsm b on a.mnemonic = b.mnemonic
where		b.release_id = (select max(release_id) from eeiuser.acctg_csm_nacsm)
		and a.base_part in (select distinct(left(part,7)) from part_customer where customer = @bill_customer)
		and isnull(empire_sop,sop) between '2012-01-01' and '2012-06-30'--@selection_beg_date and @selection_end_date
group by	a.base_part
order by    a.base_part
	


GO
