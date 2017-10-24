SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CSMAuditForActivePartAndBOM]
as
begin

-- Get BOM Records From EEH

--Get List Of Base Parts that have CSM Association
declare @CSMBaseParts table
(	BasePart varchar(25),
	Demand2012 int,
	Demand2013 int,
	Demand2014 int,
	AvgPrice numeric(20,6))

insert @CSMBaseParts
        (	BasePart,
			Demand2012,
			Demand2013,
			Demand2014,
			AvgPrice  )

select 
	Base_part,
	sum(coalesce(Total_2012_Totaldemand,0)) ,
	sum(coalesce(Total_2013_Totaldemand,0)) ,
	sum(coalesce(Total_2014_Totaldemand,0)),
	coalesce((select avg(alternate_price) from order_header where left(blanket_part,7) = base_part), 0) as AvgPrice
FROM		
	[MONITOR].[EEIUser].acctg_csm_vw_select_csmdemandwitheeiadjustments_dw2_NEW_with_MaterialCum
where 
	coalesce(Total_2012_Totaldemand,0) > 0 or coalesce(Total_2013_Totaldemand,0) >0 or coalesce(Total_2014_Totaldemand,0) > 0 
group by 
	Base_part

--Get Active parts forpurpose of identifying BOM
 
--get parts marked as Active

declare @ActiveParts table
	 (	BasePart varchar(25),
		Part varchar(25) )
		
insert	@ActiveParts
        ( BasePart, Part )


SELECT	 LEFT(blanket_part,7) as Basepart,
				MAX(blanket_part)
FROM	    [Monitor].[dbo].order_header order_header
WHERE	status = 'A'
GROUP	BY LEFT(blanket_part,7)
union
SELECT	 LEFT(part.part,7) as BasePart, MAX(part.part)
FROM	[Monitor].[dbo].part_eecustom part_eecustom
JOIN	[Monitor].[dbo].part part ON part_eecustom.part = part.part
WHERE	ISNULL(part_eecustom.CurrentRevLevel, 'N') = 'Y' AND LEFT(part.part,7) NOT IN (SELECT	DISTINCT LEFT(blanket_part,7)
														FROM	 [Monitor].[dbo].order_header order_header
														WHERE	status = 'A')
GROUP BY LEFT(part.part,7)


declare @BOMParts table
	 (	BasePart varchar(25),
		Part varchar(25),
		RawPart varchar(25),
		Quantity  numeric(20,6)
		)

insert @BOMParts

Select	left(TopPart,7),
			TopPart,
			ChildPart,
			Quantity
from		[EEHSQL1].[EEH].[dbo].[vw_RawQtyPerFinPart] 
union
Select	left(TopPart,7),
			TopPart,
			ChildPart,
			Quantity
from		[dbo].[vw_RawQtyPerFinPart] 

		


select
	CSMBP.BasePart,
	AP.Part ActivePart,
	coalesce(AP.Part, 'No Active Part') as ActivePartException,
	coalesce(BOM.BasePart, 'No BOM' ) as BOMPartException,
	AvgPrice as AvgPrice,
	Demand2012,
	Demand2013,
	Demand2014
	
from
	@CSMBaseParts CSMBP
left join
	@ActiveParts AP on CSMBP.BasePart = AP.BasePart
left join
	@BOMParts BOM on AP.Part = BOM.Part
where (CSMBP.BasePart != coalesce(AP.BasePart,'-1')) or (CSMBP.BasePart != coalesce(BOM.BasePart,'-1') )

end






	
GO
