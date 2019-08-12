SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- eeiuser.acctg_csm_sp_insert_new_base_part_unpivot_fix '2019-04','ALC0471'

CREATE procedure [EEIUser].[acctg_csm_sp_insert_new_base_part_unpivot_fix] 
@release_id varchar(7),
@base_part varchar(30)


--select @release_id = '2012-04';
--select @base_part = 'ADC0023';
--select @sp = 2.32

as 

-- 2a. Insert y Mnemonic Row

--INSERT INTO eeiuser.acctg_csm_base_part_mnemonic

--        ( release_id,
--		  FORECAST_ID ,
--		  MNEMONIC , 
--		  BASE_PART ,
--          QTY_PER ,
--          TAKE_RATE ,
--          FAMILY_ALLOCATION 
--        )
--VALUES  ( @release_id,
--		  'M' , -- FORECAST_ID - varchar(15)
--          'y'+@base_part , -- MNEMONIC - varchar(50)
--          @base_part , -- BASE_PART - varchar(30)
--          1 , -- QTY_PER - decimal
--          1 , -- TAKE_RATE - decimal
--          1   -- FAMILY_ALLOCATION - decimal
--        )


---- 3a. Insert z Mnemonic Row

--INSERT INTO eeiuser.acctg_csm_base_part_mnemonic

--        ( release_id,
--		  FORECAST_ID ,
--          MNEMONIC ,
--          BASE_PART ,
--          QTY_PER ,
--          TAKE_RATE ,
--          FAMILY_ALLOCATION
--        )
--VALUES  ( @release_id,
--		  'M' ,				-- FORECAST_ID - varchar(15)
--          'z'+@base_part ,	-- MNEMONIC - varchar(50)
--          @base_part ,		-- BASE_PART - varchar(30)
--          1 ,				-- QTY_PER - decimal
--          1 ,				-- TAKE_RATE - decimal
--          1					-- FAMILY_ALLOCATION - decimal
--        )



-- 2b. Insert Empire Factor Row
-- Header table first
begin try
insert into eeiuser.acctg_csm_NAIHS_header
(
	Release_ID
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
,	Platform
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
)
VALUES  ( @release_id , -- [RELEASE_ID] ,
          'Empire Factor' , -- [VERSION] ,
		  NULL , -- [CORE NAMEPLATE REGION MNEMONIC],
		  NULL , -- [CORE NAMEPLATE PLANT MNEMONIC],
          NULL , -- [MNEMONIC-VEHICLE] ,
          'y'+@base_part , -- [MNEMONIC-VEHICLE/PLANT] ,
          NULL , -- [MNEMONIC-PLATFORM] ,
          NULL , -- [REGION] ,
          NULL , -- [MARKET] ,
          NULL , -- [COUNTRY] ,
          NULL , -- [PLANT] ,
          NULL , -- [CITY] ,
          NULL , -- [PLANT STATE/PROVINCE] ,
          NULL , -- [SOURCE PLANT] ,
          NULL , -- [SOURCE PLANT COUNTRY] ,
          NULL , -- [SOURCE PLANT REGION] ,
          NULL , -- [DESIGN PARENT] ,
          NULL , -- [ENGINEERING GROUP] ,
          NULL , -- [MANUFACTURING GROUP] ,
          NULL , -- [MANUFACTURER] ,
          NULL , -- [SALES PARENT] ,
          NULL , -- [BRAND] ,
          NULL , -- [PLATFORM DESIGN OWNER] ,
          NULL , -- [ARCHITECTURE] ,
          NULL , -- [PLATFORM] , 
          NULL , -- [PROGRAM] ,
          NULL , -- [NAMEPLATE] ,
          NULL , -- [SOP] ,
          NULL , -- [EOP] ,
          NULL , -- [LIFECYCLE (TIME)] ,
          NULL , -- [VEHICLE] ,
          NULL , -- [ASSEMBLY TYPE] ,
          NULL , -- [STRATEGIC GROUP] ,
          NULL , -- [SALES GROUP] ,
          NULL , -- [GLOBAL NAMEPLATE] ,
          NULL , -- [PRIMARY DESIGN CENTER] ,
          NULL , -- [PRIMARY DESIGN COUNTRY],
          NULL , -- [PRIMARY DESIGN REGION],
          NULL , -- [SECONDARY DESIGN CENTER] ,
          NULL , -- [SECONDARY DESIGN COUNTRY],
          NULL , -- [SECONDARY DESIGN REGION] ,
          NULL , -- [GVW RATING] ,
          NULL , -- [GVW CLASS] ,
          NULL , -- [CAR/TRUCK] ,
          NULL , -- [PRODUCTION TYPE] , 
          NULL , -- [GLOBAL PRODUCTION SEGMENT] ,
		  NULL , -- [REGIONAL SALES SEGMENT] ,
		  NULL , -- [GLOBAL PRODUCTION PRICE CLASS],
          NULL , -- [GLOBAL SALES SEGMENT] ,
          NULL , -- [GLOBAL SALES SUB-SEGMENT] ,
          NULL , -- [GLOBAL SALES PRICE CLASS] ,
          NULL , -- [SHORT TERM RISK RATING] ,
          NULL  -- [LONG TERM RISK RATING] 
)
end try
begin catch
	throw 50000, 'Failed to insert Empire Factor row into the NAIHS header table.  Procedure: acctg_csm_sp_insert_new_base_part_unpivot.', 1; 
end catch


-- Detail table
--  (Trigger will fire, updating the CSM warehouse (legacy) table)
--- <Insert rows>	
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'M' + right('0' + convert(varchar, month(dateadd(month, row_number() over (partition by Release_ID, 'CSM', [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))), 2)
,	EffectiveYear = year(dateadd(month, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(month, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = h.Release_ID
	,	[Version] = h.[Version]
	,	[Mnemonic-Vehicle/Plant] = h.[Mnemonic-Vehicle/Plant]

	,	[Jan 2018] = 1
	,   [Feb 2018] = 1
	,   [Mar 2018] = 1
	,   [Apr 2018] = 1
	,   [May 2018] = 1
	,   [Jun 2018] = 1
	,   [Jul 2018] = 1
	,   [Aug 2018] = 1
	,   [Sep 2018] = 1
	,   [Oct 2018] = 1
	,   [Nov 2018] = 1
	,   [Dec 2018] = 1
					 
	,	[Jan 2019] = 1
	,   [Feb 2019] = 1
	,   [Mar 2019] = 1
	,   [Apr 2019] = 1
	,   [May 2019] = 1
	,   [Jun 2019] = 1
	,   [Jul 2019] = 1
	,   [Aug 2019] = 1
	,   [Sep 2019] = 1
	,   [Oct 2019] = 1
	,   [Nov 2019] = 1
	,   [Dec 2019] = 1
					 
	,	[Jan 2020] = 1
	,   [Feb 2020] = 1
	,   [Mar 2020] = 1
	,   [Apr 2020] = 1
	,   [May 2020] = 1
	,   [Jun 2020] = 1
	,   [Jul 2020] = 1
	,   [Aug 2020] = 1
	,   [Sep 2020] = 1
	,   [Oct 2020] = 1
	,   [Nov 2020] = 1
	,   [Dec 2020] = 1
					 
	,	[Jan 2021] = 1
	,   [Feb 2021] = 1
	,   [Mar 2021] = 1
	,   [Apr 2021] = 1
	,   [May 2021] = 1
	,   [Jun 2021] = 1
	,   [Jul 2021] = 1
	,   [Aug 2021] = 1
	,   [Sep 2021] = 1
	,   [Oct 2021] = 1
	,   [Nov 2021] = 1
	,   [Dec 2021] = 1
from
	eeiuser.acctg_csm_NAIHS_header h
where
	h.Release_ID = @release_id
	and h.[Version] = 'Empire Factor'
	and h.[Mnemonic-Vehicle/Plant] = 'y'+@base_part 
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
		[Jan 2018]
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
) as unpivoted
--- </Insert>	


--- <Insert rows>
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'Q' + convert(varchar, datepart(quarter, dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')))
,	EffectiveYear = year(dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = h.Release_ID
	,	[Version] = h.[Version]
	,	[Mnemonic-Vehicle/Plant] = h.[Mnemonic-Vehicle/Plant]							 
														 
	,	[Q1 2018] = 1
	,   [Q2 2018] = 1
	,   [Q3 2018] = 1
	,   [Q4 2018] = 1
					
	,	[Q1 2019] = 1
	,   [Q2 2019] = 1
	,   [Q3 2019] = 1
	,   [Q4 2019] = 1
					
	,	[Q1 2020] = 1
	,   [Q2 2020] = 1
	,   [Q3 2020] = 1
	,   [Q4 2020] = 1
					
	,	[Q1 2021] = 1
	,   [Q2 2021] = 1
	,   [Q3 2021] = 1
	,   [Q4 2021] = 1
					
	,	[Q1 2022] = 1
	,   [Q2 2022] = 1
	,   [Q3 2022] = 1
	,   [Q4 2022] = 1
			  		
	,	[Q1 2023] = 1
	,   [Q2 2023] = 1
	,   [Q3 2023] = 1
	,   [Q4 2023] = 1
			  		
	,	[Q1 2024] = 1
	,   [Q2 2024] = 1
	,   [Q3 2024] = 1
	,   [Q4 2024] = 1
			 		
	,	[Q1 2025] = 1
	,   [Q2 2025] = 1
	,   [Q3 2025] = 1
	,   [Q4 2025] = 1
					
	,	[Q1 2026] = 1
	,   [Q2 2026] = 1
	,   [Q3 2026] = 1
	,   [Q4 2026] = 1

from
	eeiuser.acctg_csm_NAIHS_header h
where
	h.Release_ID =  @release_id
	and h.[Version] = 'Empire Factor'
	and h.[Mnemonic-Vehicle/Plant] = 'y'+@base_part 
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
		[Q1 2018]
	,   [Q2 2018]
	,   [Q3 2018]
	,   [Q4 2018]
		
	,	[Q1 2019]
	,   [Q2 2019]
	,   [Q3 2019]
	,   [Q4 2019]
		
	,	[Q1 2020]
	,   [Q2 2020]
	,   [Q3 2020]
	,   [Q4 2020]
		
	,	[Q1 2021]
	,   [Q2 2021]
	,   [Q3 2021]
	,   [Q4 2021]
		
	,	[Q1 2022]
	,   [Q2 2022]
	,   [Q3 2022]
	,   [Q4 2022]
				  
	,	[Q1 2023]
	,   [Q2 2023]
	,   [Q3 2023]
	,   [Q4 2023]
				  
	,	[Q1 2024]
	,   [Q2 2024]
	,   [Q3 2024]
	,   [Q4 2024]
				 
	,	[Q1 2025]
	,   [Q2 2025]
	,   [Q3 2025]
	,   [Q4 2025]

	,	[Q1 2026]
	,   [Q2 2026]
	,   [Q3 2026]
	,   [Q4 2026]
	)
) as unpivoted
--- </Insert>



--- <Insert rows>
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'CY'
,	EffectiveYear = year(dateadd(year, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(year, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = h.Release_ID
	,	[Version] = h.[Version]
	,	[Mnemonic-Vehicle/Plant] = h.[Mnemonic-Vehicle/Plant]

	,   [CY 2018] = 1
	,   [CY 2019] = 1
	,   [CY 2020] = 1
	,   [CY 2021] = 1
	,   [CY 2022] = 1
	,   [CY 2023] = 1
	,   [CY 2024] = 1
	,   [CY 2025] = 1
	,   [CY 2026] = 1

from
	eeiuser.acctg_csm_NAIHS_header h
where
	h.Release_ID = @release_id
	and h.[Version] = 'Empire Factor'
	and h.[Mnemonic-Vehicle/Plant] = 'y'+@base_part 
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
	    [CY 2018]
	,   [CY 2019]
	,   [CY 2020]
	,   [CY 2021]
	,   [CY 2022]
	,   [CY 2023]
	,   [CY 2024]
	,   [CY 2025]
	,   [CY 2026]
	)
) as unpivoted
--- </Insert>









-- 2b. Insert Empire Adjustment Row
-- Header table first
begin try
insert into eeiuser.acctg_csm_NAIHS_header
(
	Release_ID
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
,	Platform
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
)
VALUES  ( @release_id , -- [RELEASE_ID] ,
          'Empire Adjustment' , -- [VERSION] ,
		  NULL , -- [CORE NAMEPLATE REGION MNEMONIC],
		  NULL , -- [CORE NAMEPLATE PLANT MNEMONIC],
          NULL , -- [MNEMONIC-VEHICLE] ,
          'z'+@base_part , -- [MNEMONIC-VEHICLE/PLANT] ,
          NULL , -- [MNEMONIC-PLATFORM] ,
          NULL , -- [REGION] ,
          NULL , -- [MARKET] ,
          NULL , -- [COUNTRY] ,
          NULL , -- [PLANT] ,
          NULL , -- [CITY] ,
          NULL , -- [PLANT STATE/PROVINCE] ,
          NULL , -- [SOURCE PLANT] ,
          NULL , -- [SOURCE PLANT COUNTRY] ,
          NULL , -- [SOURCE PLANT REGION] ,
          NULL , -- [DESIGN PARENT] ,
          NULL , -- [ENGINEERING GROUP] ,
          NULL , -- [MANUFACTURING GROUP] ,
          NULL , -- [MANUFACTURER] ,
          NULL , -- [SALES PARENT] ,
          NULL , -- [BRAND] ,
          NULL , -- [PLATFORM DESIGN OWNER] ,
          NULL , -- [ARCHITECTURE] ,
          NULL , -- [PLATFORM] , 
          NULL , -- [PROGRAM] ,
          NULL , -- [NAMEPLATE] ,
          NULL , -- [SOP] ,
          NULL , -- [EOP] ,
          NULL , -- [LIFECYCLE (TIME)] ,
          NULL , -- [VEHICLE] ,
          NULL , -- [ASSEMBLY TYPE] ,
          NULL , -- [STRATEGIC GROUP] ,
          NULL , -- [SALES GROUP] ,
          NULL , -- [GLOBAL NAMEPLATE] ,
          NULL , -- [PRIMARY DESIGN CENTER] ,
          NULL , -- [PRIMARY DESIGN COUNTRY],
          NULL , -- [PRIMARY DESIGN REGION],
          NULL , -- [SECONDARY DESIGN CENTER] ,
          NULL , -- [SECONDARY DESIGN COUNTRY],
          NULL , -- [SECONDARY DESIGN REGION] ,
          NULL , -- [GVW RATING] ,
          NULL , -- [GVW CLASS] ,
          NULL , -- [CAR/TRUCK] ,
          NULL , -- [PRODUCTION TYPE] , 
          NULL , -- [GLOBAL PRODUCTION SEGMENT] ,
		  NULL , -- [REGIONAL SALES SEGMENT] ,
		  NULL , -- [GLOBAL PRODUCTION PRICE CLASS],
          NULL , -- [GLOBAL SALES SEGMENT] ,
          NULL , -- [GLOBAL SALES SUB-SEGMENT] ,
          NULL , -- [GLOBAL SALES PRICE CLASS] ,
          NULL , -- [SHORT TERM RISK RATING] ,
          NULL  -- [LONG TERM RISK RATING] 
)
end try
begin catch
	throw 50000, 'Failed to insert Empire Adjustment row into the NAIHS header table.  Procedure: acctg_csm_sp_insert_new_base_part_unpivot.', 1;  
end catch



-- Detail table
--  (Trigger will fire, updating the CSM warehouse (legacy) table)
--- <Insert rows>	
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'M' + right('0' + convert(varchar, month(dateadd(month, row_number() over (partition by Release_ID, 'CSM', [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))), 2)
,	EffectiveYear = year(dateadd(month, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(month, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = h.Release_ID
	,	[Version] = h.[Version]
	,	[Mnemonic-Vehicle/Plant] = h.[Mnemonic-Vehicle/Plant]

	,	[Jan 2018] = 0
	,   [Feb 2018] = 0
	,   [Mar 2018] = 0
	,   [Apr 2018] = 0
	,   [May 2018] = 0
	,   [Jun 2018] = 0
	,   [Jul 2018] = 0
	,   [Aug 2018] = 0
	,   [Sep 2018] = 0
	,   [Oct 2018] = 0
	,   [Nov 2018] = 0
	,   [Dec 2018] = 0
					 
	,	[Jan 2019] = 0
	,   [Feb 2019] = 0
	,   [Mar 2019] = 0
	,   [Apr 2019] = 0
	,   [May 2019] = 0
	,   [Jun 2019] = 0
	,   [Jul 2019] = 0
	,   [Aug 2019] = 0
	,   [Sep 2019] = 0
	,   [Oct 2019] = 0
	,   [Nov 2019] = 0
	,   [Dec 2019] = 0
					 
	,	[Jan 2020] = 0
	,   [Feb 2020] = 0
	,   [Mar 2020] = 0
	,   [Apr 2020] = 0
	,   [May 2020] = 0
	,   [Jun 2020] = 0
	,   [Jul 2020] = 0
	,   [Aug 2020] = 0
	,   [Sep 2020] = 0
	,   [Oct 2020] = 0
	,   [Nov 2020] = 0
	,   [Dec 2020] = 0
					 
	,	[Jan 2021] = 0
	,   [Feb 2021] = 0
	,   [Mar 2021] = 0
	,   [Apr 2021] = 0
	,   [May 2021] = 0
	,   [Jun 2021] = 0
	,   [Jul 2021] = 0
	,   [Aug 2021] = 0
	,   [Sep 2021] = 0
	,   [Oct 2021] = 0
	,   [Nov 2021] = 0
	,   [Dec 2021] = 0
from
	eeiuser.acctg_csm_NAIHS_header h
where
	h.Release_ID = @release_id
	and h.[Version] = 'Empire Adjustment'
	and h.[Mnemonic-Vehicle/Plant] = 'z'+@base_part 
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
		[Jan 2018]
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
) as unpivoted
--- </Insert>	


--- <Insert rows>
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'Q' + convert(varchar, datepart(quarter, dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')))
,	EffectiveYear = year(dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(quarter, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = h.Release_ID
	,	[Version] = h.[Version]
	,	[Mnemonic-Vehicle/Plant] = h.[Mnemonic-Vehicle/Plant]							 
														 
	,	[Q1 2018] = 0
	,   [Q2 2018] = 0
	,   [Q3 2018] = 0
	,   [Q4 2018] = 0
					
	,	[Q1 2019] = 0
	,   [Q2 2019] = 0
	,   [Q3 2019] = 0
	,   [Q4 2019] = 0
					
	,	[Q1 2020] = 0
	,   [Q2 2020] = 0
	,   [Q3 2020] = 0
	,   [Q4 2020] = 0
					
	,	[Q1 2021] = 0
	,   [Q2 2021] = 0
	,   [Q3 2021] = 0
	,   [Q4 2021] = 0
					
	,	[Q1 2022] = 0
	,   [Q2 2022] = 0
	,   [Q3 2022] = 0
	,   [Q4 2022] = 0
			  		
	,	[Q1 2023] = 0
	,   [Q2 2023] = 0
	,   [Q3 2023] = 0
	,   [Q4 2023] = 0
			  		
	,	[Q1 2024] = 0
	,   [Q2 2024] = 0
	,   [Q3 2024] = 0
	,   [Q4 2024] = 0
			 		
	,	[Q1 2025] = 0
	,   [Q2 2025] = 0
	,   [Q3 2025] = 0
	,   [Q4 2025] = 0
					
	,	[Q1 2026] = 0
	,   [Q2 2026] = 0
	,   [Q3 2026] = 0
	,   [Q4 2026] = 0

from
	eeiuser.acctg_csm_NAIHS_header h
where
	h.Release_ID = @release_id
	and h.[Version] = 'Empire Adjustment'
	and h.[Mnemonic-Vehicle/Plant] = 'z'+@base_part 
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
		[Q1 2018]
	,   [Q2 2018]
	,   [Q3 2018]
	,   [Q4 2018]
		
	,	[Q1 2019]
	,   [Q2 2019]
	,   [Q3 2019]
	,   [Q4 2019]
		
	,	[Q1 2020]
	,   [Q2 2020]
	,   [Q3 2020]
	,   [Q4 2020]
		
	,	[Q1 2021]
	,   [Q2 2021]
	,   [Q3 2021]
	,   [Q4 2021]
		
	,	[Q1 2022]
	,   [Q2 2022]
	,   [Q3 2022]
	,   [Q4 2022]
				  
	,	[Q1 2023]
	,   [Q2 2023]
	,   [Q3 2023]
	,   [Q4 2023]
				  
	,	[Q1 2024]
	,   [Q2 2024]
	,   [Q3 2024]
	,   [Q4 2024]
				 
	,	[Q1 2025]
	,   [Q2 2025]
	,   [Q3 2025]
	,   [Q4 2025]

	,	[Q1 2026]
	,   [Q2 2026]
	,   [Q3 2026]
	,   [Q4 2026]
	)
) as unpivoted
--- </Insert>



--- <Insert rows>
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	Period = 'CY'
,	EffectiveYear = year(dateadd(year, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1'))
,	EffectiveDT = dateadd(year, row_number() over (partition by Release_ID, Version, [Mnemonic-Vehicle/Plant] order by [Mnemonic-Vehicle/Plant]) - 1, '2018-1-1')
,	SalesDemand
from
(	select
		Header_ID = h.ID
	,	Release_ID = h.Release_ID
	,	[Version] = h.[Version]
	,	[Mnemonic-Vehicle/Plant] = h.[Mnemonic-Vehicle/Plant]

	,   [CY 2018] = 0
	,   [CY 2019] = 0
	,   [CY 2020] = 0
	,   [CY 2021] = 0
	,   [CY 2022] = 0
	,   [CY 2023] = 0
	,   [CY 2024] = 0
	,   [CY 2025] = 0
	,   [CY 2026] = 0

from
	eeiuser.acctg_csm_NAIHS_header h
where
	h.Release_ID = @release_id
	and h.[Version] = 'Empire Adjustment'
	and h.[Mnemonic-Vehicle/Plant] = 'z'+@base_part 
) as pivoted
unpivot
(
	SalesDemand for SalesDemands in 
	(
	    [CY 2018]
	,   [CY 2019]
	,   [CY 2020]
	,   [CY 2021]
	,   [CY 2022]
	,   [CY 2023]
	,   [CY 2024]
	,   [CY 2025]
	,   [CY 2026]
	)
) as unpivoted
--- </Insert>








GO
