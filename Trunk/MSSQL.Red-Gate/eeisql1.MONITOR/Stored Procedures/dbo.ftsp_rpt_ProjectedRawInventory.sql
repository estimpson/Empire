SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	PROCEDURE	[dbo].[ftsp_rpt_ProjectedRawInventory]

as


BEGIN
DECLARE		@FinishedNetDemand TABLE (
			FinPart varchar(25),
			FinOrderNo int,
			FinLineID int,
			FinReqDT datetime,
			FinBalance numeric (20,6),
			FinOnHandQty numeric (20,6))
			
DECLARE		@RawNetDemand TABLE (
			RawPart varchar(25),
			RawOrderNo int,
			RawLineID int,
			RawReqDT datetime,
			RawBalance numeric (20,6),
			RawOnHandQty numeric (20,6),
			RawStdCost	numeric (20,6))
			

DECLARE		@RawNetDemandSummary TABLE (
			RawPart varchar(25),
			RawReqDT datetime,
			RawBalance numeric (20,6),
			RawOnHandQty numeric (20,6),
			RawStdCost	numeric (20,6),
			RawExtended numeric (20,6))
			
DECLARE		@RawInventoryNoDemand TABLE (
			RawPart varchar(25),
			RawOnhandQty numeric (20,6),
			RawStdCost	numeric (20,6),
			ExtendedRawOnHand numeric (20,6))


INSERT	@FinishedNetDemand
        ( FinPart ,
          FinOrderNo ,
          FinLineID ,
          FinReqDT ,
          FinBalance ,
          FinOnHandQty
        )

SELECT		NetMPS.part,
			NetMPS.OrderNo,
			NetMPS.LineID,
			NetMPS.RequiredDT,
			NetMPS.Balance,
			NetMPS.OnHandQty
FROM		[EEHSQL1].[EEH].[FT].NetMPS NetMPS
JOIN		[EEHSQL1].[EEH].[dbo].Part Part ON NetMPS.part = Part.Part
WHERE		Part.type = 'F'
ORDER BY	1,2,3

INSERT	@RawNetDemand
        ( RawPart ,
          RawOrderNo ,
          RawLineID ,
          RawReqDT ,
          RawBalance ,
          RawOnHandQty ,
          RawStdCost
        )
SELECT		NetMPS.part,
			NetMPS.OrderNo,
			NetMPS.LineID,
			NetMPS.RequiredDT,
			NetMPS.Balance,
			NetMPS.OnHandQty,
			Part_Standard.Cost_cum
FROM		[EEHSQL1].[EEH].[FT].NetMPS NetMPS
JOIN		[EEHSQL1].[EEH].[dbo].Part Part ON NetMPS.part = Part.Part
JOIN		[EEHSQL1].[EEH].[dbo].Part_standard Part_Standard ON Part.part = part_standard.part
WHERE		Part.type = 'R' AND
			orderNo > 0
ORDER BY	1,2,3

INSERT	@RawInventoryNoDemand
        ( RawPart , RawOnhandQty , RawStdCost, ExtendedRawOnhand )
SELECT	object.part,
		SUM(Std_quantity),
		MAX(cost_cum),
		SUM(Std_quantity)*MAX(cost_cum)
FROM	[EEHSQL1].[EEH].[dbo].object object
JOIN	[EEHSQL1].[EEH].[dbo].part part ON object.part = part.part
JOIN	[EEHSQL1].[EEH].[dbo].part_standard part_standard ON object.part = part_standard.part
JOIN	[EEHSQL1].[EEH].[dbo].location location ON object.location = location.code
WHERE	part.type = 'R' AND
		ISNULL(NULLIF(secured_location,''), 'N') != 'Y' 
AND		object.part NOT IN  (SELECT RawPart FROM @RawNetDemand RawNetDemand)
GROUP	BY	object.part




INSERT	@RawNetDemandSummary
        ( RawPart ,
          RawReqDT ,
          RawBalance ,
          RawOnHandQty ,
          RawStdCost ,
          RawExtended
        )

SELECT		NetMPS.Part,
			[MONITOR].[FT].[fn_TruncDate]('wk',RequiredDT),
			SUM(NetMPS.Balance),
			SUM(NetMPS.OnHandQty),
			MAX(cost_cum),
			(SUM(NetMPS.OnHandQty)*MAX(cost_cum))
FROM		[EEHSQL1].[EEH].[FT].NetMPS NetMPS
JOIN		[EEHSQL1].[EEH].[dbo].Part Part ON NetMPS.part = Part.Part
JOIN		[EEHSQL1].[EEH].[dbo].Part_standard Part_Standard ON Part.part = part_standard.part
WHERE		Part.type = 'R' AND
			orderNo > 0
GROUP BY	NetMPS.part,
			RequiredDT
UNION

SELECT	RawPart,
		EntryDT,
		0,
		RawOnHandQty,
		RawStdCost,
		ExtendedRawOnHand 
FROM
[@RawInventoryNoDemand] CROSS JOIN
(SELECT * FROM [MONITOR].[dbo].[fn_Calendar_StartCurrentSunday] (
   '2010-07-31'
  ,'wk'
  ,1
  ,NULL)) WeekCalendar


--Flatten Finished Goods Per Raw Part

truncate table	dbo.RawPartFinishedParts

insert	dbo.RawPartFinishedParts

SELECT	RawPart,
		'( '+ FinishedPart + ' Qty: '+ CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,2),Quantity))+
		' Dmd: '+(CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,0),ISNULL((SELECT SUM(quantity) FROM order_detail WHERE part_number = FinishedPart),0) ))) + ' )',
		Quantity
FROM	[EEHSQL1].[EEH].[dbo].[vweeiBOM]


declare	@RawPart varchar(25),
		@FinishedPartList varchar(1000)

declare @FlatFinishedGoods table (
		
	RawPart	varchar(25),
	FinishedParts	varchar(1000))

declare	Rawpartlist cursor local for
select distinct RawPart 
from	dbo.RawPartFinishedParts
open		Rawpartlist 
fetch	Rawpartlist into	@RawPart

While		 @@fetch_status = 0
Begin	
Select	@FinishedPartList  = ''


Select		@FinishedPartList = @FinishedPartList + FinishedPart +', '
from		dbo.RawPartFinishedParts where RawPart = @RawPart
group by	FinishedPart



insert	@FlatFinishedGoods
Select	@Rawpart,
		@FinishedPartList
		
		

fetch	Rawpartlist into	@RawPart

END

truncate table FlatFinishedPart
insert	FlatFinishedPart
Select	RawPart,
		left(FinishedParts,datalength(FinishedParts)-2)
	
from		@FlatFinishedGoods

SELECT	*
FROM	@RawNetDemandSummary RawNettedDemand
LEFT JOIN	dbo.FlatFinishedPart ON RawNettedDemand.RawPart = dbo.FlatFinishedPart.RawPart

END


GO
