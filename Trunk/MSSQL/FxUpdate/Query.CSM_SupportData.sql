select distinct
	acn.Manufacturer
from
	EEIUser.acctg_csm_NAIHS acn
where
	acn.Release_ID =
		(	select
				max(acn.Release_ID)
			from
				EEIUser.acctg_csm_NAIHS acn
		)
	and acn.Version = 'CSM'

select distinct
	acn.Manufacturer
,	acn.Nameplate
,	acn.Vehicle
,	acn.[Mnemonic-Vehicle]
from
	EEIUser.acctg_csm_NAIHS acn
where
	acn.Release_ID =
		(	select
				max(acn.Release_ID)
			from
				EEIUser.acctg_csm_NAIHS acn
		)
	and acn.Version = 'CSM'

select distinct
	acn.Manufacturer
,	acn.Nameplate
,	acn.Vehicle
,	acn.[Mnemonic-Vehicle]
,	acn.Program
,	acn.SOP
,	acn.EOP
from
	EEIUser.acctg_csm_NAIHS acn
where
	acn.Release_ID =
		(	select
				max(acn.Release_ID)
			from
				EEIUser.acctg_csm_NAIHS acn
		)
	and acn.Version = 'CSM'
