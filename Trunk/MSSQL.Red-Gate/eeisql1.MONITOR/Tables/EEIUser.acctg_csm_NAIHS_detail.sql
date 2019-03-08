CREATE TABLE [EEIUser].[acctg_csm_NAIHS_detail]
(
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mnemonic-Vehicle/Plant] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EffectiveYear] [int] NOT NULL,
[EffectiveDT] [datetime] NULL,
[SalesDemand] [decimal] (10, 2) NULL,
[Header_ID] [int] NOT NULL,
[Period] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create trigger [EEIUser].[acctg_csm_NAIHS_detail_TriggerUpdate]
on [EEIUser].[acctg_csm_NAIHS_detail]
after update as
begin
	set nocount on;
	begin try
		if exists (	
				select
					i.Release_ID, i.[Mnemonic-Vehicle/Plant], i.[Version], i.EffectiveYear, i.EffectiveDT, i.Header_ID, i.[Period]
				from
					Inserted i
				except
				select 
					d.Release_ID, d.[Mnemonic-Vehicle/Plant], d.[Version], d.EffectiveYear, d.EffectiveDT, d.Header_ID, d.[Period]
				from
					Deleted d )
			throw 50000, 'Updating is only allowed on column SalesDemand.', 1
	end try
	begin catch
		if xact_state() <> 0
			rollback transaction;
		throw;
	end catch
end;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE trigger [EEIUser].[tr_csm_NAIHS_detail_IUD] on [EEIUser].[acctg_csm_NAIHS_detail] for insert, update, delete
as
delete
	n
from
	EEIUser.acctg_csm_NAIHS n
where
	n.ID in
		(	select
		 		i.Header_ID
		 	from
		 		Inserted i
			union all
			select
				d.Header_ID
			from
				Deleted d
		)

insert
	EEIUser.acctg_csm_NAIHS
(
	ID
,	Release_ID 
,	[Version]
,	[Core Nameplate Region Mnemonic]
,	[Core Nameplate Plant Mnemonic]
,	[Mnemonic-Vehicle]
,	[Mnemonic-Vehicle/Plant]
,	[Mnemonic-Platform]
,	Region
,	Market
,	Country
,	Plant
,	City
,	[Plant State/Province]
,	[Source Plant]
,	[Source Plant Country]
,	[Source Plant Region]
,	[Design Parent]
,	[Engineering Group]
,	[Manufacturing Group]
,	Manufacturer
,	[Sales Parent]
,	Brand
,	[Platform Design Owner]
,	Architecture
,	[Platform]
,	Program
,	Nameplate
,	SOP
,	EOP
,	[Lifecycle (Time)]
,	Vehicle
,	[Assembly Type]
,	[Strategic Group]
,	[Sales Group]
,	[Global Nameplate]
,	[Primary Design Center]
,	[Primary Design Country]
,	[Primary Design Region]
,	[Secondary Design Center]
,	[Secondary Design Country]
,	[Secondary Design Region]
,	[GVW Rating]
,	[GVW Class]
,	[Car/Truck]
,	[Production Type]
,	[Global Production Segment]
,	[Regional Sales Segment]
,	[Global Production Price Class]
,	[Global Sales Segment]
,	[Global Sales Sub-Segment]
,	[Global Sales Price Class]
,	[Short Term Risk Rating]
,	[Long Term Risk Rating]
,	[Jan 2008]
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
,	[Q1 2008]
,	[Q2 2008]
,	[Q3 2008]
,	[Q4 2008]
,	[Q1 2009]
,	[Q2 2009]
,	[Q3 2009]
,	[Q4 2009]
,	[Q1 2010]
,	[Q2 2010]
,	[Q3 2010]
,	[Q4 2010]
,	[Q1 2011]
,	[Q2 2011]
,	[Q3 2011]
,	[Q4 2011]
,	[Q1 2012]
,	[Q2 2012]
,	[Q3 2012]
,	[Q4 2012]
,	[Q1 2013]
,	[Q2 2013]
,	[Q3 2013]
,	[Q4 2013]
,	[Q1 2014]
,	[Q2 2014]
,	[Q3 2014]
,	[Q4 2014]
,	[Q1 2015]
,	[Q2 2015]
,	[Q3 2015]
,	[Q4 2015]
,	[Q1 2016]
,	[Q2 2016]
,	[Q3 2016]
,	[Q4 2016]
,	[Q1 2017]
,	[Q2 2017]
,	[Q3 2017]
,	[Q4 2017]
,	[Q1 2018]
,	[Q2 2018]
,	[Q3 2018]
,	[Q4 2018]
,	[Q1 2019]
,	[Q2 2019]
,	[Q3 2019]
,	[Q4 2019]
,	[Q1 2020]
,	[Q2 2020]
,	[Q3 2020]
,	[Q4 2020]
,	[Q1 2021]
,	[Q2 2021]
,	[Q3 2021]
,	[Q4 2021]
,	[Q1 2022]
,	[Q2 2022]
,	[Q3 2022]
,	[Q4 2022]
,	[Q1 2023]
,	[Q2 2023]
,	[Q3 2023]
,	[Q4 2023]
,	[Q1 2024]
,	[Q2 2024]
,	[Q3 2024]
,	[Q4 2024]
,	[Q1 2025]
,	[Q2 2025]
,	[Q3 2025]
,	[Q4 2025]
,	[CY 2008]
,	[CY 2009]
,	[CY 2010]
,	[CY 2011]
,	[CY 2012]
,	[CY 2013]
,	[CY 2014]
,	[CY 2015]
,	[CY 2016]
,	[CY 2017]
,	[CY 2018]
,	[CY 2019]
,	[CY 2020]
,	[CY 2021]
,	[CY 2022]
,	[CY 2023]
,	[CY 2024]
,	[CY 2025]
)
select
	nh.ID
,	nh.Release_ID 
,	nh.[Version]
,	nh.[Core Nameplate Region Mnemonic]
,	nh.[Core Nameplate Plant Mnemonic]
,	nh.[Mnemonic-Vehicle]
,	nh.[Mnemonic-Vehicle/Plant]
,	nh.[Mnemonic-Platform]
,	nh.Region
,	nh.Market
,	nh.Country
,	nh.Plant
,	nh.City
,	nh.[Plant State/Province]
,	nh.[Source Plant]
,	nh.[Source Plant Country]
,	nh.[Source Plant Region]
,	nh.[Design Parent]
,	nh.[Engineering Group]
,	nh.[Manufacturing Group]
,	nh.Manufacturer
,	nh.[Sales Parent]
,	nh.Brand
,	nh.[Platform Design Owner]
,	nh.Architecture
,	nh.[Platform]
,	nh.Program
,	nh.Nameplate
,	nh.SOP
,	nh.EOP
,	nh.[Lifecycle (Time)]
,	nh.Vehicle
,	nh.[Assembly Type]
,	nh.[Strategic Group]
,	nh.[Sales Group]
,	nh.[Global Nameplate]
,	nh.[Primary Design Center]
,	nh.[Primary Design Country]
,	nh.[Primary Design Region]
,	nh.[Secondary Design Center]
,	nh.[Secondary Design Country]
,	nh.[Secondary Design Region]
,	nh.[GVW Rating]
,	nh.[GVW Class]
,	nh.[Car/Truck]
,	nh.[Production Type]
,	nh.[Global Production Segment]
,	nh.[Regional Sales Segment]
,	nh.[Global Production Price Class]
,	nh.[Global Sales Segment]
,	nh.[Global Sales Sub-Segment]
,	nh.[Global Sales Price Class]
,	nh.[Short Term Risk Rating]
,	nh.[Long Term Risk Rating]
,	[Jan 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M01')
,	[Feb 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M02')
,	[Mar 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M03')
,	[Apr 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M04')
,	[May 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M05')
,	[Jun 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M06')
,	[Jul 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M07')
,	[Aug 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M08')
,	[Sep 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M09')
,	[Oct 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M10')
,	[Nov 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M11')
,	[Dec 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M12')
,	[Jan 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M01')
,	[Feb 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M02')
,	[Mar 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M03')
,	[Apr 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M04')
,	[May 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M05')
,	[Jun 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M06')
,	[Jul 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M07')
,	[Aug 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M08')
,	[Sep 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M09')
,	[Oct 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M10')
,	[Nov 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M11')
,	[Dec 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M12')
,	[Jan 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M01')
,	[Feb 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M02')
,	[Mar 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M03')
,	[Apr 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M04')
,	[May 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M05')
,	[Jun 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M06')
,	[Jul 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M07')
,	[Aug 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M08')
,	[Sep 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M09')
,	[Oct 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M10')
,	[Nov 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M11')
,	[Dec 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M12')
,	[Jan 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M01')
,	[Feb 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M02')
,	[Mar 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M03')
,	[Apr 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M04')
,	[May 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M05')
,	[Jun 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M06')
,	[Jul 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M07')
,	[Aug 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M08')
,	[Sep 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M09')
,	[Oct 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M10')
,	[Nov 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M11')
,	[Dec 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M12')
,	[Jan 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M01')
,	[Feb 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M02')
,	[Mar 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M03')
,	[Apr 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M04')
,	[May 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M05')
,	[Jun 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M06')
,	[Jul 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M07')
,	[Aug 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M08')
,	[Sep 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M09')
,	[Oct 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M10')
,	[Nov 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M11')
,	[Dec 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M12')
,	[Jan 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M01')
,	[Feb 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M02')
,	[Mar 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M03')
,	[Apr 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M04')
,	[May 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M05')
,	[Jun 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M06')
,	[Jul 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M07')
,	[Aug 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M08')
,	[Sep 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M09')
,	[Oct 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M10')
,	[Nov 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M11')
,	[Dec 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M12')
,	[Jan 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M01')
,	[Feb 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M02')
,	[Mar 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M03')
,	[Apr 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M04')
,	[May 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M05')
,	[Jun 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M06')
,	[Jul 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M07')
,	[Aug 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M08')
,	[Sep 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M09')
,	[Oct 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M10')
,	[Nov 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M11')
,	[Dec 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M12')
,	[Jan 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M01')
,	[Feb 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M02')
,	[Mar 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M03')
,	[Apr 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M04')
,	[May 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M05')
,	[Jun 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M06')
,	[Jul 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M07')
,	[Aug 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M08')
,	[Sep 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M09')
,	[Oct 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M10')
,	[Nov 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M11')
,	[Dec 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M12')
,	[Jan 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M01')
,	[Feb 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M02')
,	[Mar 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M03')
,	[Apr 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M04')
,	[May 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M05')
,	[Jun 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M06')
,	[Jul 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M07')
,	[Aug 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M08')
,	[Sep 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M09')
,	[Oct 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M10')
,	[Nov 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M11')
,	[Dec 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M12')
,	[Jan 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M01')
,	[Feb 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M02')
,	[Mar 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M03')
,	[Apr 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M04')
,	[May 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M05')
,	[Jun 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M06')
,	[Jul 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M07')
,	[Aug 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M08')
,	[Sep 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M09')
,	[Oct 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M10')
,	[Nov 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M11')
,	[Dec 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M12')
,	[Jan 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M01')
,	[Feb 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M02')
,	[Mar 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M03')
,	[Apr 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M04')
,	[May 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M05')
,	[Jun 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M06')
,	[Jul 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M07')
,	[Aug 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M08')
,	[Sep 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M09')
,	[Oct 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M10')
,	[Nov 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M11')
,	[Dec 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M12')
,	[Jan 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M01')
,	[Feb 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M02')
,	[Mar 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M03')
,	[Apr 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M04')
,	[May 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M05')
,	[Jun 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M06')
,	[Jul 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M07')
,	[Aug 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M08')
,	[Sep 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M09')
,	[Oct 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M10')
,	[Nov 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M11')
,	[Dec 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M12')
,	[Jan 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M01')
,	[Feb 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M02')
,	[Mar 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M03')
,	[Apr 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M04')
,	[May 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M05')
,	[Jun 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M06')
,	[Jul 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M07')
,	[Aug 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M08')
,	[Sep 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M09')
,	[Oct 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M10')
,	[Nov 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M11')
,	[Dec 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M12')

,	[Q1 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'Q1')
,	[Q2 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'Q2')
,	[Q3 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'Q3')
,	[Q4 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'Q4')

,	[Q1 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'Q1')
,	[Q2 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'Q2')
,	[Q3 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'Q3')
,	[Q4 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'Q4')

,	[Q1 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'Q1')
,	[Q2 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'Q2')
,	[Q3 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'Q3')
,	[Q4 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'Q4')

,	[Q1 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'Q1')
,	[Q2 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'Q2')
,	[Q3 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'Q3')
,	[Q4 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'Q4')

,	[Q1 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'Q1')
,	[Q2 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'Q2')
,	[Q3 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'Q3')
,	[Q4 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'Q4')

,	[Q1 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'Q1')
,	[Q2 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'Q2')
,	[Q3 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'Q3')
,	[Q4 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'Q4')

,	[Q1 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'Q1')
,	[Q2 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'Q2')
,	[Q3 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'Q3')
,	[Q4 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'Q4')

,	[Q1 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'Q1')
,	[Q2 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'Q2')
,	[Q3 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'Q3')
,	[Q4 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'Q4')

,	[Q1 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'Q1')
,	[Q2 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'Q2')
,	[Q3 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'Q3')
,	[Q4 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'Q4')

,	[Q1 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'Q1')
,	[Q2 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'Q2')
,	[Q3 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'Q3')
,	[Q4 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'Q4')

,	[Q1 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'Q1')
,	[Q2 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'Q2')
,	[Q3 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'Q3')
,	[Q4 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'Q4')

,	[Q1 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'Q1')
,	[Q2 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'Q2')
,	[Q3 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'Q3')
,	[Q4 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'Q4')

,	[Q1 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'Q1')
,	[Q2 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'Q2')
,	[Q3 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'Q3')
,	[Q4 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'Q4')

,	[Q1 2021] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2021 and Period = 'Q1')
,	[Q2 2021] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2021 and Period = 'Q2')
,	[Q3 2021] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2021 and Period = 'Q3')
,	[Q4 2021] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2021 and Period = 'Q4')

,	[Q1 2022] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2022 and Period = 'Q1')
,	[Q2 2022] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2022 and Period = 'Q2')
,	[Q3 2022] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2022 and Period = 'Q3')
,	[Q4 2022] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2022 and Period = 'Q4')

,	[Q1 2023] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2023 and Period = 'Q1')
,	[Q2 2023] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2023 and Period = 'Q2')
,	[Q3 2023] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2023 and Period = 'Q3')
,	[Q4 2023] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2023 and Period = 'Q4')

,	[Q1 2024] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2024 and Period = 'Q1')
,	[Q2 2024] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2024 and Period = 'Q2')
,	[Q3 2024] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2024 and Period = 'Q3')
,	[Q4 2024] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2024 and Period = 'Q4')

,	[Q1 2025] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2025 and Period = 'Q1')
,	[Q2 2025] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2025 and Period = 'Q2')
,	[Q3 2025] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2025 and Period = 'Q3')
,	[Q4 2025] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2025 and Period = 'Q4')

,	[CY 2008] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'CY')
,	[CY 2009] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'CY')
,	[CY 2010] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'CY')
,	[CY 2011] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'CY')
,	[CY 2012] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'CY')
,	[CY 2013] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'CY')
,	[CY 2014] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'CY')
,	[CY 2015] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'CY')
,	[CY 2016] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'CY')
,	[CY 2017] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'CY')
,	[CY 2018] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'CY')
,	[CY 2019] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'CY')
,	[CY 2020] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'CY')
,	[CY 2021] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2021 and Period = 'CY')
,	[CY 2022] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2022 and Period = 'CY')
,	[CY 2023] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2023 and Period = 'CY')
,	[CY 2024] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2024 and Period = 'CY')
,	[CY 2025] = (select min(SalesDemand) from EEIUser.acctg_csm_NAIHS_detail where Header_ID = ID and EffectiveYear = 2025 and Period = 'CY')
from
	EEIUser.acctg_csm_NAIHS_header nh
where
	nh.ID in
		(	select
		 		i.Header_ID
		 	from
		 		Inserted i
			union all
			select
				d.Header_ID
			from
				Deleted d
		)

--delete
--SalesForecast (table that was once a view)

--insert
--SalesForecast View (table that was once a view)

GO
DISABLE TRIGGER [EEIUser].[tr_csm_NAIHS_detail_IUD] ON [EEIUser].[acctg_csm_NAIHS_detail]
GO
ALTER TABLE [EEIUser].[acctg_csm_NAIHS_detail] ADD CONSTRAINT [PK__acctg_cs__9E9692CD7C598B98] PRIMARY KEY CLUSTERED  ([Release_ID], [EffectiveYear], [Header_ID], [Period]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RID_Include_SalesDemand] ON [EEIUser].[acctg_csm_NAIHS_detail] ([Release_ID], [Mnemonic-Vehicle/Plant], [EffectiveDT]) INCLUDE ([EffectiveYear], [Period], [SalesDemand], [Version]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_NAIHS_detail] ADD CONSTRAINT [UQ__acctg_cs__EBBF137B4B63B087] UNIQUE NONCLUSTERED  ([Release_ID], [Version], [Mnemonic-Vehicle/Plant], [EffectiveYear], [Period]) ON [PRIMARY]
GO
