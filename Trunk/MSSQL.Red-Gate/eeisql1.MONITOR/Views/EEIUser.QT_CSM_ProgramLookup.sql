SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEIUser].[QT_CSM_ProgramLookup]
as
select
	Program = acn.Program
,	OEM = acn.Manufacturer
,	Nameplate = acn.Nameplate
,	ModelYear =
		case
			when acn.[CY 2010] > 0 then '2010'
			when acn.[CY 2011] > 0 then '2011'
			when acn.[CY 2012] > 0 then '2012'
			when acn.[CY 2013] > 0 then '2013'
			when acn.[CY 2014] > 0 then '2014'
			when acn.[CY 2015] > 0 then '2015'
			when acn.[CY 2016] > 0 then '2016'
			when acn.[CY 2017] > 0 then '2017'
			when acn.[CY 2018] > 0 then '2018'
			when acn.[CY 2019] > 0 then '2019'
		end
,	SOP = acn.SOP
,	EOP = acn.EOP
from
	EEIUser.acctg_csm_NAIHS acn
where
	acn.RELEASE_ID =
		(	select
				max(RELEASE_ID)
			from
				EEIUser.acctg_csm_NAIHS
			where
				Program = acn.Program
		)
group by
	acn.Program
,	acn.Manufacturer
,	acn.Nameplate
,	case
		when acn.[CY 2010] > 0 then '2010'
		when acn.[CY 2011] > 0 then '2011'
		when acn.[CY 2012] > 0 then '2012'
		when acn.[CY 2013] > 0 then '2013'
		when acn.[CY 2014] > 0 then '2014'
		when acn.[CY 2015] > 0 then '2015'
		when acn.[CY 2016] > 0 then '2016'
		when acn.[CY 2017] > 0 then '2017'
		when acn.[CY 2018] > 0 then '2018'
		when acn.[CY 2019] > 0 then '2019'
	end
,	acn.SOP
,	acn.EOP
GO
