SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [EEIUser].[acctg_csm_NAIHS_detail_view]
as
select
	ReleaseID
,	MnemonicVehiclePlant
,	[Version]
,	EffectiveMonth = month(dateadd(month, row_number() over (partition by ReleaseId, Version, MnemonicVehiclePlant order by MnemonicVehiclePlant) - 1, '2008-1-1'))
,	EffectiveYear = year(dateadd(month, row_number() over (partition by ReleaseId, Version, MnemonicVehiclePlant order by MnemonicVehiclePlant) - 1, '2008-1-1'))
,	EffectiveDT = dateadd(month, row_number() over (partition by ReleaseId, Version, MnemonicVehiclePlant order by MnemonicVehiclePlant) - 1, '2008-1-1')
,	SalesDemand
from
(
	select
		n.RELEASE_ID as ReleaseId
	,	n.[Version]
	,	n.[Mnemonic-Vehicle/Plant] as MnemonicVehiclePlant
	,	[Jan 2008] = coalesce(n.[Jan 2008], 0)
	,	[Feb 2008] = coalesce(n.[Feb 2008], 0)
	,	[Mar 2008] = coalesce(n.[Mar 2008], 0)
	,	[Apr 2008] = coalesce(n.[Apr 2008], 0)
	,	[May 2008] = coalesce(n.[May 2008], 0)
	,	[Jun 2008] = coalesce(n.[Jun 2008], 0)
	,	[Jul 2008] = coalesce(n.[Jul 2008], 0)
	,	[Aug 2008] = coalesce(n.[Aug 2008], 0)
	,	[Sep 2008] = coalesce(n.[Sep 2008], 0)
	,	[Oct 2008] = coalesce(n.[Oct 2008], 0)
	,	[Nov 2008] = coalesce(n.[Nov 2008], 0)
	,	[Dec 2008] = coalesce(n.[Dec 2008], 0)

	,	[Jan 2009] = coalesce(n.[Jan 2009], 0)
	,	[Feb 2009] = coalesce(n.[Feb 2009], 0)
	,	[Mar 2009] = coalesce(n.[Mar 2009], 0)
	,	[Apr 2009] = coalesce(n.[Apr 2009], 0)
	,	[May 2009] = coalesce(n.[May 2009], 0)
	,	[Jun 2009] = coalesce(n.[Jun 2009], 0)
	,	[Jul 2009] = coalesce(n.[Jul 2009], 0)
	,	[Aug 2009] = coalesce(n.[Aug 2009], 0)
	,	[Sep 2009] = coalesce(n.[Sep 2009], 0)
	,	[Oct 2009] = coalesce(n.[Oct 2009], 0)
	,	[Nov 2009] = coalesce(n.[Nov 2009], 0)
	,	[Dec 2009] = coalesce(n.[Dec 2009], 0)

	,	[Jan 2010] = coalesce(n.[Jan 2010], 0)
	,	[Feb 2010] = coalesce(n.[Feb 2010], 0)
	,	[Mar 2010] = coalesce(n.[Mar 2010], 0)
	,	[Apr 2010] = coalesce(n.[Apr 2010], 0)
	,	[May 2010] = coalesce(n.[May 2010], 0)
	,	[Jun 2010] = coalesce(n.[Jun 2010], 0)
	,	[Jul 2010] = coalesce(n.[Jul 2010], 0)
	,	[Aug 2010] = coalesce(n.[Aug 2010], 0)
	,	[Sep 2010] = coalesce(n.[Sep 2010], 0)
	,	[Oct 2010] = coalesce(n.[Oct 2010], 0)
	,	[Nov 2010] = coalesce(n.[Nov 2010], 0)
	,	[Dec 2010] = coalesce(n.[Dec 2010], 0)

	,	[Jan 2011] = coalesce(n.[Jan 2011], 0)
	,	[Feb 2011] = coalesce(n.[Feb 2011], 0)
	,	[Mar 2011] = coalesce(n.[Mar 2011], 0)
	,	[Apr 2011] = coalesce(n.[Apr 2011], 0)
	,	[May 2011] = coalesce(n.[May 2011], 0)
	,	[Jun 2011] = coalesce(n.[Jun 2011], 0)
	,	[Jul 2011] = coalesce(n.[Jul 2011], 0)
	,	[Aug 2011] = coalesce(n.[Aug 2011], 0)
	,	[Sep 2011] = coalesce(n.[Sep 2011], 0)
	,	[Oct 2011] = coalesce(n.[Oct 2011], 0)
	,	[Nov 2011] = coalesce(n.[Nov 2011], 0)
	,	[Dec 2011] = coalesce(n.[Dec 2011], 0)

	,	[Jan 2012] = coalesce(n.[Jan 2012], 0)
	,	[Feb 2012] = coalesce(n.[Feb 2012], 0)
	,	[Mar 2012] = coalesce(n.[Mar 2012], 0)
	,	[Apr 2012] = coalesce(n.[Apr 2012], 0)
	,	[May 2012] = coalesce(n.[May 2012], 0)
	,	[Jun 2012] = coalesce(n.[Jun 2012], 0)
	,	[Jul 2012] = coalesce(n.[Jul 2012], 0)
	,	[Aug 2012] = coalesce(n.[Aug 2012], 0)
	,	[Sep 2012] = coalesce(n.[Sep 2012], 0)
	,	[Oct 2012] = coalesce(n.[Oct 2012], 0)
	,	[Nov 2012] = coalesce(n.[Nov 2012], 0)
	,	[Dec 2012] = coalesce(n.[Dec 2012], 0)

	,	[Jan 2013] = coalesce(n.[Jan 2013], 0)
	,	[Feb 2013] = coalesce(n.[Feb 2013], 0)
	,	[Mar 2013] = coalesce(n.[Mar 2013], 0)
	,	[Apr 2013] = coalesce(n.[Apr 2013], 0)
	,	[May 2013] = coalesce(n.[May 2013], 0)
	,	[Jun 2013] = coalesce(n.[Jun 2013], 0)
	,	[Jul 2013] = coalesce(n.[Jul 2013], 0)
	,	[Aug 2013] = coalesce(n.[Aug 2013], 0)
	,	[Sep 2013] = coalesce(n.[Sep 2013], 0)
	,	[Oct 2013] = coalesce(n.[Oct 2013], 0)
	,	[Nov 2013] = coalesce(n.[Nov 2013], 0)
	,	[Dec 2013] = coalesce(n.[Dec 2013], 0)

	,	[Jan 2014] = coalesce(n.[Jan 2014], 0)
	,	[Feb 2014] = coalesce(n.[Feb 2014], 0)
	,	[Mar 2014] = coalesce(n.[Mar 2014], 0)
	,	[Apr 2014] = coalesce(n.[Apr 2014], 0)
	,	[May 2014] = coalesce(n.[May 2014], 0)
	,	[Jun 2014] = coalesce(n.[Jun 2014], 0)
	,	[Jul 2014] = coalesce(n.[Jul 2014], 0)
	,	[Aug 2014] = coalesce(n.[Aug 2014], 0)
	,	[Sep 2014] = coalesce(n.[Sep 2014], 0)
	,	[Oct 2014] = coalesce(n.[Oct 2014], 0)
	,	[Nov 2014] = coalesce(n.[Nov 2014], 0)
	,	[Dec 2014] = coalesce(n.[Dec 2014], 0)

	,	[Jan 2015] = coalesce(n.[Jan 2015], 0)
	,	[Feb 2015] = coalesce(n.[Feb 2015], 0)
	,	[Mar 2015] = coalesce(n.[Mar 2015], 0)
	,	[Apr 2015] = coalesce(n.[Apr 2015], 0)
	,	[May 2015] = coalesce(n.[May 2015], 0)
	,	[Jun 2015] = coalesce(n.[Jun 2015], 0)
	,	[Jul 2015] = coalesce(n.[Jul 2015], 0)
	,	[Aug 2015] = coalesce(n.[Aug 2015], 0)
	,	[Sep 2015] = coalesce(n.[Sep 2015], 0)
	,	[Oct 2015] = coalesce(n.[Oct 2015], 0)
	,	[Nov 2015] = coalesce(n.[Nov 2015], 0)
	,	[Dec 2015] = coalesce(n.[Dec 2015], 0)

	,	[Jan 2016] = coalesce(n.[Jan 2016], 0)
	,	[Feb 2016] = coalesce(n.[Feb 2016], 0)
	,	[Mar 2016] = coalesce(n.[Mar 2016], 0)
	,	[Apr 2016] = coalesce(n.[Apr 2016], 0)
	,	[May 2016] = coalesce(n.[May 2016], 0)
	,	[Jun 2016] = coalesce(n.[Jun 2016], 0)
	,	[Jul 2016] = coalesce(n.[Jul 2016], 0)
	,	[Aug 2016] = coalesce(n.[Aug 2016], 0)
	,	[Sep 2016] = coalesce(n.[Sep 2016], 0)
	,	[Oct 2016] = coalesce(n.[Oct 2016], 0)
	,	[Nov 2016] = coalesce(n.[Nov 2016], 0)
	,	[Dec 2016] = coalesce(n.[Dec 2016], 0)

	,	[Jan 2017] = coalesce(n.[Jan 2017], 0)
	,	[Feb 2017] = coalesce(n.[Feb 2017], 0)
	,	[Mar 2017] = coalesce(n.[Mar 2017], 0)
	,	[Apr 2017] = coalesce(n.[Apr 2017], 0)
	,	[May 2017] = coalesce(n.[May 2017], 0)
	,	[Jun 2017] = coalesce(n.[Jun 2017], 0)
	,	[Jul 2017] = coalesce(n.[Jul 2017], 0)
	,	[Aug 2017] = coalesce(n.[Aug 2017], 0)
	,	[Sep 2017] = coalesce(n.[Sep 2017], 0)
	,	[Oct 2017] = coalesce(n.[Oct 2017], 0)
	,	[Nov 2017] = coalesce(n.[Nov 2017], 0)
	,	[Dec 2017] = coalesce(n.[Dec 2017], 0)

	,	[Jan 2018] = coalesce(n.[Jan 2018], 0)
	,	[Feb 2018] = coalesce(n.[Feb 2018], 0)
	,	[Mar 2018] = coalesce(n.[Mar 2018], 0)
	,	[Apr 2018] = coalesce(n.[Apr 2018], 0)
	,	[May 2018] = coalesce(n.[May 2018], 0)
	,	[Jun 2018] = coalesce(n.[Jun 2018], 0)
	,	[Jul 2018] = coalesce(n.[Jul 2018], 0)
	,	[Aug 2018] = coalesce(n.[Aug 2018], 0)
	,	[Sep 2018] = coalesce(n.[Sep 2018], 0)
	,	[Oct 2018] = coalesce(n.[Oct 2018], 0)
	,	[Nov 2018] = coalesce(n.[Nov 2018], 0)
	,	[Dec 2018] = coalesce(n.[Dec 2018], 0)
	
	,	[Jan 2019] = coalesce(n.[Jan 2019], 0)
	,	[Feb 2019] = coalesce(n.[Feb 2019], 0)
	,	[Mar 2019] = coalesce(n.[Mar 2019], 0)
	,	[Apr 2019] = coalesce(n.[Apr 2019], 0)
	,	[May 2019] = coalesce(n.[May 2019], 0)
	,	[Jun 2019] = coalesce(n.[Jun 2019], 0)
	,	[Jul 2019] = coalesce(n.[Jul 2019], 0)
	,	[Aug 2019] = coalesce(n.[Aug 2019], 0)
	,	[Sep 2019] = coalesce(n.[Sep 2019], 0)
	,	[Oct 2019] = coalesce(n.[Oct 2019], 0)
	,	[Nov 2019] = coalesce(n.[Nov 2019], 0)
	,	[Dec 2019] = coalesce(n.[Dec 2019], 0)
	
	,	[Jan 2020] = coalesce(n.[Jan 2020], 0)
	,	[Feb 2020] = coalesce(n.[Feb 2020], 0)
	,	[Mar 2020] = coalesce(n.[Mar 2020], 0)
	,	[Apr 2020] = coalesce(n.[Apr 2020], 0)
	,	[May 2020] = coalesce(n.[May 2020], 0)
	,	[Jun 2020] = coalesce(n.[Jun 2020], 0)
	,	[Jul 2020] = coalesce(n.[Jul 2020], 0)
	,	[Aug 2020] = coalesce(n.[Aug 2020], 0)
	,	[Sep 2020] = coalesce(n.[Sep 2020], 0)
	,	[Oct 2020] = coalesce(n.[Oct 2020], 0)
	,	[Nov 2020] = coalesce(n.[Nov 2020], 0)
	,	[Dec 2020] = coalesce(n.[Dec 2020], 0)

	,	[Jan 2021] = coalesce(n.[Jan 2021], 0)
	,	[Feb 2021] = coalesce(n.[Feb 2021], 0)
	,	[Mar 2021] = coalesce(n.[Mar 2021], 0)
	,	[Apr 2021] = coalesce(n.[Apr 2021], 0)
	,	[May 2021] = coalesce(n.[May 2021], 0)
	,	[Jun 2021] = coalesce(n.[Jun 2021], 0)
	,	[Jul 2021] = coalesce(n.[Jul 2021], 0)
	,	[Aug 2021] = coalesce(n.[Aug 2021], 0)
	,	[Sep 2021] = coalesce(n.[Sep 2021], 0)
	,	[Oct 2021] = coalesce(n.[Oct 2021], 0)
	,	[Nov 2021] = coalesce(n.[Nov 2021], 0)
	,	[Dec 2021] = coalesce(n.[Dec 2021], 0)
	from
		eeiuser.acctg_csm_NAIHS n
) as np
unpivot
(
	SalesDemand for SalesDemands in 
	(
		[Jan 2008]
	,	[Feb 2008]
	,	[Mar 2008]
	,	[Apr 2008]
	,	[May 2008]
	,	[Jun 2008]
	,	[Jul 2008]
	,	[Aug 2008]
	,	[Sep 2008]
	,	[Oct 2008]
	,	[Nov 2008]
	,	[Dec 2008]
	,	[Jan 2009]
	,	[Feb 2009]
	,	[Mar 2009]
	,	[Apr 2009]
	,	[May 2009]
	,	[Jun 2009]
	,	[Jul 2009]
	,	[Aug 2009]
	,	[Sep 2009]
	,	[Oct 2009]
	,	[Nov 2009]
	,	[Dec 2009]
	,	[Jan 2010]
	,	[Feb 2010]
	,	[Mar 2010]
	,	[Apr 2010]
	,	[May 2010]
	,	[Jun 2010]
	,	[Jul 2010]
	,	[Aug 2010]
	,	[Sep 2010]
	,	[Oct 2010]
	,	[Nov 2010]
	,	[Dec 2010]
	,	[Jan 2011]
	,	[Feb 2011]
	,	[Mar 2011]
	,	[Apr 2011]
	,	[May 2011]
	,	[Jun 2011]
	,	[Jul 2011]
	,	[Aug 2011]
	,	[Sep 2011]
	,	[Oct 2011]
	,	[Nov 2011]
	,	[Dec 2011]
	,	[Jan 2012]
	,	[Feb 2012]
	,	[Mar 2012]
	,	[Apr 2012]
	,	[May 2012]
	,	[Jun 2012]
	,	[Jul 2012]
	,	[Aug 2012]
	,	[Sep 2012]
	,	[Oct 2012]
	,	[Nov 2012]
	,	[Dec 2012]
	,	[Jan 2013]
	,	[Feb 2013]
	,	[Mar 2013]
	,	[Apr 2013]
	,	[May 2013]
	,	[Jun 2013]
	,	[Jul 2013]
	,	[Aug 2013]
	,	[Sep 2013]
	,	[Oct 2013]
	,	[Nov 2013]
	,	[Dec 2013]
	,	[Jan 2014]
	,	[Feb 2014]
	,	[Mar 2014]
	,	[Apr 2014]
	,	[May 2014]
	,	[Jun 2014]
	,	[Jul 2014]
	,	[Aug 2014]
	,	[Sep 2014]
	,	[Oct 2014]
	,	[Nov 2014]
	,	[Dec 2014]
	,	[Jan 2015]
	,	[Feb 2015]
	,	[Mar 2015]
	,	[Apr 2015]
	,	[May 2015]
	,	[Jun 2015]
	,	[Jul 2015]
	,	[Aug 2015]
	,	[Sep 2015]
	,	[Oct 2015]
	,	[Nov 2015]
	,	[Dec 2015]
	,	[Jan 2016]
	,	[Feb 2016]
	,	[Mar 2016]
	,	[Apr 2016]
	,	[May 2016]
	,	[Jun 2016]
	,	[Jul 2016]
	,	[Aug 2016]
	,	[Sep 2016]
	,	[Oct 2016]
	,	[Nov 2016]
	,	[Dec 2016]
	,	[Jan 2017]
	,	[Feb 2017]
	,	[Mar 2017]
	,	[Apr 2017]
	,	[May 2017]
	,	[Jun 2017]
	,	[Jul 2017]
	,	[Aug 2017]
	,	[Sep 2017]
	,	[Oct 2017]
	,	[Nov 2017]
	,	[Dec 2017]
	,	[Jan 2018]
	,	[Feb 2018]
	,	[Mar 2018]
	,	[Apr 2018]
	,	[May 2018]
	,	[Jun 2018]
	,	[Jul 2018]
	,	[Aug 2018]
	,	[Sep 2018]
	,	[Oct 2018]
	,	[Nov 2018]
	,	[Dec 2018]
	,	[Jan 2019]
	,	[Feb 2019]
	,	[Mar 2019]
	,	[Apr 2019]
	,	[May 2019]
	,	[Jun 2019]
	,	[Jul 2019]
	,	[Aug 2019]
	,	[Sep 2019]
	,	[Oct 2019]
	,	[Nov 2019]
	,	[Dec 2019]
	,	[Jan 2020]
	,	[Feb 2020]
	,	[Mar 2020]
	,	[Apr 2020]
	,	[May 2020]
	,	[Jun 2020]
	,	[Jul 2020]
	,	[Aug 2020]
	,	[Sep 2020]
	,	[Oct 2020]
	,	[Nov 2020]
	,	[Dec 2020]	
	,	[Jan 2021]
	,	[Feb 2021]
	,	[Mar 2021]
	,	[Apr 2021]
	,	[May 2021]
	,	[Jun 2021]
	,	[Jul 2021]
	,	[Aug 2021]
	,	[Sep 2021]
	,	[Oct 2021]
	,	[Nov 2021]
	,	[Dec 2021]	
	)
) as nu

GO
