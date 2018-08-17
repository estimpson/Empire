SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [Programs].[xOEMs]
as
select
	OEMs.Name
,	OEMs.LastEOP
,	OEMs.FirstRelease
,	OEMs.LastRelease
,	CurrentProgramFlag = case when OEMs.LastEOP > getdate() then 1 else 0 end
,	CurrentReleaseFlag = case when OEMs.LastRelease =
		(	select
				max(acn.Release_ID)
			from
				MONITOR.EEIUser.acctg_csm_NAIHS acn
			where
				acn.[Mnemonic-Vehicle/Plant] not like '[yz]%'
		) then 1 else 0 end
from
	(	select
			Name = acn.Manufacturer
		,	LastEOP = max(EOP)
		,	FirstRelease = min(acn.Release_ID)
		,	LastRelease = max(acn.Release_ID)
		from
			MONITOR.EEIUser.acctg_csm_NAIHS acn
		where
			acn.[Mnemonic-Vehicle/Plant] not like '[yz]%'
			and acn.Manufacturer is not null
		group by
			acn.Manufacturer
	) OEMs
GO
