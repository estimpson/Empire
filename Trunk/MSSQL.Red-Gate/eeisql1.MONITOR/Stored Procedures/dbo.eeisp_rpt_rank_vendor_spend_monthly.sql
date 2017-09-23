SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_rank_vendor_spend_monthly] as
begin

--eeisp_rpt_rank_vendor_spend_monthly

--Created 09/15/2009	Andre S. Boulanger


Declare	@release_id varchar(30),
		@RawPart varchar(25),
		@BasePartList varchar(1000),
		@OEMS varchar(1000),
		@Programs varchar(1000),
		@Vehicles varchar(1000)

Select	@Release_id = max(release_id) from eeiuser.acctg_csm_NACSM



Create table		#BasePartDemand
					
				 (	BasePart varchar(25),
		sep_09 numeric(20,6),
		oct_09 numeric(20,6),
		nov_09 numeric(20,6),
		dec_09 numeric(20,6),
		jan_10 numeric(20,6),
		feb_10 numeric(20,6),
		mar_10 numeric(20,6),
		apr_10 numeric(20,6),
		may_10 numeric(20,6),
		jun_10 numeric(20,6),
		jul_10 numeric(20,6),
		aug_10 numeric(20,6),
		sep_10 numeric(20,6),
		oct_10 numeric(20,6),
		nov_10 numeric(20,6),
		dec_10 numeric(20,6),
		demandY1 numeric(20,6),
		demandy2 numeric(20,6),Primary Key (BasePart))
					
Insert	#BasePartDemand

select 	Base_Part,
		isNull(sum(sep_10),0),
		isNull(sum(oct_10),0),
		isNull(sum(nov_10),0),
		isNull(sum(dec_10),0),
		isNull(sum(jan_10),0),
		isNull(sum(feb_10),0),
		isNull(sum(mar_10),0),
		isNull(sum(apr_10),0),
		isNull(sum(may_10),0),
		isNull(sum(jun_10),0),
		isNull(sum(jul_10),0),
		isNull(sum(aug_10),0),
		isNull(sum(sep_10),0),
		isNull(sum(oct_10),0),
		isNull(sum(nov_10),0),
		isNull(sum(dec_10),0),
		isNull(sum(total_2009),0),
		isNull(sum(total_2010),0)		
from		[EEIUser].[acctg_csm_vw_select_total_demand]
group by	Base_Part
having	(sum(total_2009)+sum(total_2010))>50




Create table #BOM (	TopPart varchar(25),
					RawPart	varchar(25),
					PartName varchar(255),
					PrimaryVendor varchar(25),
					StdPack numeric(20,6),
					LeadTime numeric(20,6),
					QtyPer numeric(20,6),
					MaterialCum numeric(20,6), 
					DollarsPer numeric(20,6), Primary Key (TopPart, RawPart))


Insert	#BOM
Select	TopPart,
		ChildPart,
		max(p.name),
		max(isNull(default_vendor, 'NoPrimaryVendor')),
		max(isNull(parti.standard_pack,0)),
		max(isnull(pv.fabauthdays,0)),
		max(Quantity),
		max(material_cum),
		max(Quantity*material_cum) 
 from	[EEHSQL1].[EEH].[dbo].[vw_RawQtyPerFinPart] BOM
join		[EEHSQL1].[EEH].[dbo].[part_standard] ps on BOM.ChildPart = ps.Part
join		[EEHSQL1].[EEH].[dbo].[part] p on BOM.ChildPart = p.Part
join		[EEHSQL1].[EEH].[dbo].[part_online] po on BOM.ChildPart = po.Part
join		[EEHSQL1].[EEH].[dbo].[part_inventory] parti on BOM.ChildPart = parti.Part
left join	[EEHSQL1].[EEH].[dbo].[part_vendor] pv on BOM.ChildPart = pv.part and po.default_vendor = pv.vendor

group by	TopPart,
		ChildPart
		
Create table	#CurrentBOM (
			TopPart varchar(25),	
			BasePart varchar(25),
			BasePartDemand varchar(35),
			RawPart	varchar(25),
			PartName varchar(255),
			PrimaryVendor varchar(25),
			StdPack numeric(20,6),
			LeadTime numeric(20,6),
			QtyPer numeric(20,6),
			MaterialCum numeric(20,6), 
			DollarsPer numeric(20,6), 
			Oem varchar(1000),
			Program varchar(1000),
			vehicle varchar(1000), Primary Key (TopPart, RawPart))
							
Insert	#CurrentBOM
Select	TopPart,
		left(TopPart,7),
		left(TopPart,7) + ' ('+Substring(convert(varchar(1000),DemandY1 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY1 ))-1 )+')' + ' ('+Substring(convert(varchar(1000),DemandY2 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY2 ))-1 )+')',
		RawPart,
		PartName,
		PrimaryVendor,
		StdPack,
		LeadTime,
		QtyPer,
		MaterialCum , 
		DollarsPer,
		isNull(Oem, 'No OEM Defined'),
		isNull(Program, 'No Program Defined'),
		isNull(Vehicle, 'No Vehicle Defined')
From	#BOM BOM
join		part_eecustom on BOM.TopPart = part_eecustom.part and CurrentRevLevel = 'Y'
join		#BasePartDemand BPD on left(TopPart,7) = BPD.BasePart
left	join	FlatCSM on BPD.BAsePart = FlatCSM.BasePart



declare @FlatWhereUsed table (
		
	RawPart		varchar(25),
	BaseParts	varchar(1000))

declare	Rawpartlist cursor local for
select	distinct Rawpart 
from		#CurrentBOM

open	Rawpartlist 
fetch	Rawpartlist into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@BasePartList  = ''


Select	@BasePartList = @BasePartList + BasePartDemand +', '
from		#CurrentBOM 
where	Rawpart = @RawPart
group by	BasePartDemand


insert	@FlatWhereUsed
Select	@RawPart,
		@BasePartList		

fetch	Rawpartlist into @Rawpart

end

declare @FlatOEMUsed table (
		
	RawPart		varchar(25),
	OEM	varchar(1000))

declare	Rawpartlist2 cursor local for
select	distinct Rawpart 
from		#CurrentBOM

open	Rawpartlist2
fetch	Rawpartlist2 into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@OEMS  = ''


Select	@OEMS = @OEMS + OEM +', '
from		#CurrentBOM 
where	Rawpart = @RawPart
group by	OEM


insert	@FlatOEMUsed
Select	@RawPart,
		@OEMS	

fetch	Rawpartlist2 into @Rawpart

end

declare @FlatProgramUsed table (
		
	RawPart		varchar(25),
	Program	varchar(1000))

declare	Rawpartlist3 cursor local for
select	distinct Rawpart 
from		#CurrentBOM

open	Rawpartlist3
fetch	Rawpartlist3 into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@Programs  = ''


Select	@Programs = @Programs + Program +', '
from		#CurrentBOM 
where	Rawpart = @RawPart
group by	Program


insert	@FlatProgramUsed
Select	@RawPart,
		@Programs	

fetch	Rawpartlist3 into @Rawpart

end

declare @FlatVehicleUsed table (
		
	RawPart		varchar(25),
	Vehicle	varchar(1000))

declare	Rawpartlist4 cursor local for
select	distinct Rawpart 
from		#CurrentBOM

open	Rawpartlist4 
fetch	Rawpartlist4 into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@Vehicles  = ''


Select	@Vehicles = @Vehicles + Vehicle +', '
from		#CurrentBOM 
where	Rawpart = @RawPart
group by	Vehicle


insert	@FlatVehicleUsed
Select	@RawPart,
		@Vehicles	

fetch	Rawpartlist4 into @Rawpart

end



Select	BOM.PrimaryVendor,
		BOM.RawPart,
		PartName,
		FOEM.OEM,
		FPU.Program,
		FVU.Vehicle,
		max(StdPack) as StdPack,
		max(LeadTime) as LeadTime,
		max(MaterialCum) as Cost,
		sum(sep_10*QtyPer) as Qty_sep_10,		 
		sum(sep_10*DollarsPer) as Spend_sep_10,
		sum(oct_10*QtyPer) as Qty_oct_10, 
		sum(oct_10*DollarsPer) as spend_oct_10,
		sum(nov_10*QtyPer) as Qty_nov_10,		 
		sum(nov_10*DollarsPer) as Spend_nov_10,
		sum(dec_10*QtyPer) as Qty_dec_10, 
		sum(dec_10*DollarsPer) as spend_dec_10,
		sum(jan_10*QtyPer) as Qty_jan_10,		 
		sum(jan_10*DollarsPer) as Spend_jan_10,
		sum(feb_10*QtyPer) as Qty_feb_10, 
		sum(feb_10*DollarsPer) as spend_feb_10,
		sum(mar_10*QtyPer) as Qty_mar_10,		 
		sum(mar_10*DollarsPer) as Spend_mar_10,
		sum(apr_10*QtyPer) as Qty_apr_10, 
		sum(apr_10*DollarsPer) as spend_apr_10,
		sum(may_10*QtyPer) as Qty_may_10,		 
		sum(may_10*DollarsPer) as Spend_may_10,
		sum(jun_10*QtyPer) as Qty_jun_10, 
		sum(jun_10*DollarsPer) as spend_jun_10,
		sum(jul_10*QtyPer) as Qty_jul_10,		 
		sum(jul_10*DollarsPer) as Spend_jul_10,
		sum(aug_10*QtyPer) as Qty_aug_10, 
		sum(aug_10*DollarsPer) as spend_aug_10,
		sum(sep_10*QtyPer) as Qty_sep_10,		 
		sum(sep_10*DollarsPer) as Spend_sep_10,
		sum(oct_10*QtyPer) as Qty_oct_10, 
		sum(oct_10*DollarsPer) as Spend_oct_10,
		sum(nov_10*QtyPer) as Qty_nov_10, 
		sum(nov_10*DollarsPer) as spend_nov_10,
		sum(dec_10*QtyPer) as Qty_dec_10, 
		sum(dec_10*DollarsPer) as spend_dec_10,		
		substring(BaseParts,1,datalength(BaseParts)-2) as WhereUsed
from		#BasePartDemand BPD
left join	#CurrentBOM BOM on BPD.BasePart = BOM.BasePart
left join	@FlatWhereUsed FWU on BOM.RawPart = FWU.RawPart
left join	@FlatOEMUsed FOEM on BOM.RawPart = FOEM.RawPart
left join	@FlatProgramUsed FPU on BOM.RawPart = FPU.RawPart
left join	@FlatVehicleUsed FVU on BOM.RawPart = FVU.RawPart
group by	BOM.PrimaryVendor,
		BOM.RawPart,
		PartName,
		BaseParts,
		FOEM.OEM,
		FPU.Program,
		FVU.Vehicle
order	by 11 DESC

end
GO
