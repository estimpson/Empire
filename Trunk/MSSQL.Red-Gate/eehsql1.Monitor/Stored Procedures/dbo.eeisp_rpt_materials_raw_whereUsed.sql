SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_raw_whereUsed]
as
Begin


--Declare Variables
Declare	@RawPart varchar(25),
		@BasePartList varchar(1000),
		@OEMList varchar(1000),
		@PlatformList varchar(1000),
		@SOPEOP varchar(1000),
		@OEMS varchar(1000),
		@Programs varchar(1000),
		@Vehicles varchar(1000)



-- Begin - Base Part Demand from CSM data in Troy's Database
Create table		#BasePartCSMDemand
				 (	BasePart		varchar(25),
					DemandY1	numeric(20,6),
					DemandY2	numeric(20,6), 
					AvgDemandY1Y2	numeric(20,6), Primary Key (BasePart))
					
Insert	#BasePartCSMDemand

select 	Base_Part,
		isNull(sum(total_2009),0),
		isNull(sum(total_2010),0),
		(sum(total_2009)+sum(total_2010))/2
from		[EEISQL1].[Monitor].[EEIUser].[acctg_csm_vw_select_total_demand]
group by	Base_Part
having	(sum(total_2009)+sum(total_2010))>50




-- End - Base Part Demand from CSM data in Troy's Database
Create table		#BasePartSOPEOP
				 (	BasePart		varchar(25) Not Null,
					Customer		VArchar(50) Null,
					EmpireSOPEOP	varchar(255) Null, Primary Key (BasePart))
					
Insert	#BasePartSOPEOP
Select	Base_part,
		min(Customer),
		min(Base_part+ '  '+ isNull(convert(varchar(25), Empire_sop, 110), 'Please Define Empire SOP')+', '+isNull(convert(varchar(25), Empire_eop,110), 'Please Define Empire EOP'))
from		[EEISQL1].[Monitor].[EEIUser].[acctg_csm_base_part_mnemonic]
group by BAse_Part

-- Begin - Get Flat CSM

Create table		#FlatCSM
				 (	BasePart		varchar(25) Not Null,
					Oem		VArchar(1000) Null,
					Program	varchar(1000) Null,
					vehicle varchar(1000),
					EmpireSOPEOP varchar(1000), Primary Key (BasePart))
					
Insert	#FlatCSM
Select	FlatCSM.BasePart,
		Oem,
		Program,
		vehicle,
		EmpireSOPEOP
from		[EEISQL1].[Monitor].[dbo].FlatCSM FlatCSM
left  join	 #BasePartSOPEOP BasePartSOPEOP on  FlatCSM.BasePart = BasePartSOPEOP.Basepart



-- End -  Get Flat CSM

-- Begin - Get Distinct BasePart, Raw Part from BOM fro EEH Bill of Material for Where Used Purposes
Create table #BOM (	TopBasePart varchar(25),
					RawPart	varchar(25), 
					QtyPer numeric(20,6), Primary Key (TopBasePart, RawPart))

Insert	#BOM
Select	substring(TopPart,1, 7),
		ChildPart,
		Quantity
from		[dbo].[vw_RawQtyPerFinPart] BOM
where	TopPart in (Select max(part)
from part
where class = 'M' and type = 'F'
and part not like '%PT%' and part not like '%-RW%' and part in (Select TopPart from [dbo].[vw_RawQtyPerFinPart])
group by left(part,7)) and
ChildPart in  (Select Part from ft.wkNMPS)

		
-- End - Get BasePart, Raw Part from BOM fro EEH Bill of Material for Where Used Purposes



declare @FlatWhereUsed table (
		
	RawPart		varchar(25),
	BaseParts	varchar(1000))

declare	Rawpartlist cursor local for
select	distinct Rawpart 
from		#BOM BOM
where	RawPart in (Select Part from ft.wkNMPS)

open	Rawpartlist 
fetch	Rawpartlist into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@BasePartList  = ''


Select	@BasePartList = @BasePartList + ' '+ isNull( [BasePart], [TopBasePart]) +' '+isNULL(( '('+Substring(convert(varchar(1000),DemandY1 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY1 ))-1 )+')' + '('+Substring(convert(varchar(1000),DemandY2 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY2 ))-1 )+')'),'') +', '
from		#BOM BOM
left join	#BasePartCSMDemand BPD on BOM.TopBasePart = BPD.BasePart
where	Rawpart = @RawPart 
group by	isNull( [BasePart], [TopBasePart]),
		[BasePart],
		[TopBasePart],
		isNULL(( '('+Substring(convert(varchar(1000),DemandY1 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY1 ))-1 )+')' + '('+Substring(convert(varchar(1000),DemandY2 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY2 ))-1 )+')'),'') ,
		BPD.DemandY1,
		BPD.DemandY2
		


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
from		#BOM
open	Rawpartlist2
fetch	Rawpartlist2 into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@OEMS  = ''


Select	@OEMS = @OEMS + isNull(OEM,'') +', '
from		#BOM BOM
left join	#FlatCSM  FlatCSM on BOM.TopBasePart = FlatCSM.BasePart	 
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
from		#BOM

open	Rawpartlist3
fetch	Rawpartlist3 into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@Programs  = ''


Select	@Programs = @Programs + isNull(Program,'') +', '
from		#BOM BOM
left join	#FlatCSM  FlatCSM on BOM.TopBasePart = FlatCSM.BasePart
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
from		#BOM

open	Rawpartlist4 
fetch	Rawpartlist4 into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@Vehicles  = ''


Select	@Vehicles = @Vehicles + isNull(Vehicle,'') +', '
from		#BOM BOM
left join	#FlatCSM  FlatCSM on BOM.TopBasePart = FlatCSM.BasePart 
where	Rawpart = @RawPart
group by	Vehicle


insert	@FlatVehicleUsed
Select	@RawPart,
		@Vehicles	

fetch	Rawpartlist4 into @Rawpart

end

declare @FlatSOPEOP table (
		
	RawPart		varchar(25),
	SOPEOP	varchar(1000))

declare	Rawpartlist5 cursor local for
select	distinct Rawpart 
from		#BOM

open	Rawpartlist5 
fetch	Rawpartlist5 into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@SOPEOP  = ''


Select	@SOPEOP = @SOPEOP + isNull(EmpireSOPEOP,'') +', '
from		#BOM BOM
left join	#FlatCSM  FlatCSM on BOM.TopBasePart = FlatCSM.BasePart 
where	Rawpart = @RawPart
group by	EmpireSOPEOP 


insert	@FlatSOPEOP
Select	@RawPart,
		@SOPEOP	

fetch	Rawpartlist5 into @Rawpart

end







Select	ChildPart,
		BaseParts,
		OEM,
		Program,
		Vehicle,
		SOPEOP
		
from		(Select distinct RAWpart as ChildPart
			from #BOM) ChildParts

left join	@FlatWhereUsed FlatWhereUsedBasePart on ChildParts.ChildPart = FlatWhereUsedBasePart.RawPart
left join	@FlatOEMUsed FlatOEMUsed on ChildParts.ChildPart = FlatOEMUsed.RawPart
left join	@FlatProgramUsed FlatProgramUsed on ChildParts.ChildPart = FlatProgramUsed.RawPart
left join	@FlatVehicleUsed FlatVehicleUsed on ChildParts.ChildPart = FlatVehicleUsed.RawPart
left join	@FlatSOPEOP FlatSOPEOP on ChildParts.ChildPart = FlatSOPEOP.RawPart


end
GO
