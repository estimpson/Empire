SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_FrozenMateriaCUMForecastTabular] 

as 

Begin

declare 
       		@currentdate				datetime,
			@firstdayof2priormonth		datetime,
       		@firstdayof1priormonth		datetime,
       		@firstdayofcurrentmonth 	datetime,
       		@firstdayofcurrentmonth1 	datetime,
       		@firstdayofcurrentmonth2 	datetime,
       		@firstdayofcurrentmonth3 	datetime,
       		@firstdayofcurrentmonth4 	datetime,
       		@firstdayofyear				datetime
       		
       		Select @currentdate = getdate()
       		
       		Select	@firstdayof2priormonth	= dateadd(mm,-2,ft.fn_truncdate('mm', @currentdate))
       		Select	@firstdayof1priormonth = dateadd(mm,1,@firstdayof2priormonth)
       		Select	@firstdayofcurrentmonth = dateadd(mm,2,@firstdayof2priormonth)
       		Select	@firstdayofcurrentmonth1 = dateadd(mm,3,@firstdayof2priormonth)
       		Select	@firstdayofcurrentmonth2 = dateadd(mm,4,@firstdayof2priormonth)
       		Select	@firstdayofcurrentmonth3 = dateadd(mm,5,@firstdayof2priormonth)
       		Select	@firstdayofcurrentmonth4 = dateadd(mm,6,@firstdayof2priormonth)
       		

Create table	#MonthlyBuckets (  MonthDT datetime,
							NextMonthDT datetime,
							Period int,
							FiscalYear int, Primary Key (MonthDT) )
Insert	#MonthlyBuckets (	MonthDT,
						NextMonthDT,
						Period,
						FiscalYear )

select		EntryDT,
			dateadd(mm,1,EntryDT),
			datepart(mm, EntryDT),
			datepart(yy, EntryDT)
from			(Select	dateadd(mm, -2, EntryDT) EntryDT from [dbo].[fn_Calendar_StartCurrentMonth] (Null,'mm',1,7)) Months

Create table	#TempHistoryForeCast (	
							Ftype char(1),
							Company varchar(10),
							BasePart varchar(25),
							Part varchar(25),
							Requirementmonth datetime,
							ForeCastEEIQty numeric(20,6),
							ForeCastFrozenMaterialCUM numeric(20,6),
							TransferPriceExtended numeric(20,6),
							SalesForeast numeric(20,6), Primary Key (Ftype, Company, Part, RequirementMonth) )
Insert	#TempHistoryForecast (			
							Ftype,
							Company,
							BasePart,
							Part,
							RequirementMonth,
							ForeCastEEIQty,
							ForeCastFrozenMaterialCUM,
							TransferPriceExtended,
							SalesForeast )

Select		'F',
			Company,
			BasePart,
			Part_number,
			(CASE WHEN ft.fn_Truncdate('mm', date_due)< ft.fn_Truncdate('mm', getdate()) THEN ft.fn_Truncdate('mm', getdate())ELSE ft.fn_Truncdate('mm', date_due) END )  as RequirementMonth,
			sum(qty_projected) as ForeCastEEIQty,
			sum(qty_projected*frozen_material_cum) as 	ForeCastFrozenMaterialCUM,
			sum(eeiMaterialCumExt) as TransferPriceExtended,
			sum(Extended) as SalesForeast
			
			 
from		vw_eei_sales_forecast
join		part_standard on vw_eei_sales_forecast.part_number = part_standard.part
where		date_due < (Select	max(EntryDT) from [dbo].[fn_Calendar_StartCurrentMonth] (Null,'mm',1,6))
group by	Company,
			BasePart,
			Part_number,
			(CASE WHEN ft.fn_Truncdate('mm', date_due)< ft.fn_Truncdate('mm', getdate()) THEN ft.fn_Truncdate('mm', getdate())ELSE ft.fn_Truncdate('mm', date_due) END ) 
UNION		ALL	
Select		'H',
			Company,
			BasePart,
			part_standard.Part,
			ft.fn_Truncdate('mm', date_shipped),
			sum(qty_shipped) as ShippedEEIQty,
			sum(qty_shipped*frozen_material_cum) as 	ShippedFrozenMaterialCUM,
			sum(eeiMaterialCumExt) as TransferPriceExtended,
			sum(Extended) as Shipped
 		 
from		vw_eei_sales_history
join		part_standard on vw_eei_sales_history.part = part_standard.part
where		date_shipped >= dateadd(mm ,-2, ft.fn_Truncdate('mm', getdate()))
group by	Company,
			BasePart,
			part_standard.Part,
			ft.fn_Truncdate('mm', date_shipped)	
			
Create table	#ForeCast (	Company varchar(10),
							BasePart varchar(25),
							Part varchar(25),
							Requirementmonth datetime,
							ForeCastEEIQty numeric(20,6),
							ForeCastFrozenMaterialCUM numeric(20,6),
							TransferPriceExtended numeric(20,6),
							SalesForeast numeric(20,6), Primary Key (Company, Part, RequirementMonth) )
Insert		#Forecast (		Company,
							BasePart,
							Part,
							RequirementMonth,
							ForeCastEEIQty,
							ForeCastFrozenMaterialCUM,
							TransferPriceExtended,
							SalesForeast )
			Select			Company,
							BasePart,
							Part,
							RequirementMonth,
							sum(isNull(ForeCastEEIQty,0)) ,
							sum(isNull(ForeCastFrozenMaterialCUM,0)),
							sum(isNull(TransferPriceExtended,0)) ,
							sum(isNull (SalesForeast,0)) 
			from			#TempHistoryForecast
			group	by		Company,
							BasePart,
							Part,
							RequirementMonth	
			


Create	Table #PartCalendar
		(	Company varchar(10),
			BasePart varchar(25),
			Part varchar(25),
			RequirementMonth datetime, Primary Key( Company, Part, RequirementMonth))
			
			
			
Insert #PartCalendar

Select	Company,
		BasePart,
		Part,
		MonthDT
From	(Select distinct	Company,
							BasePart,
							Part 
			from	#Forecast ) PartList
cross join 	#MonthlyBuckets

Select		#PartCalendar.Company as Company,
			left(#PartCalendar.Part,3) as Customer,
			#PartCalendar.BasePart as BasePart,
			#PartCalendar.Part as Part,
			#PartCalendar.RequirementMonth as ReqMonth,
			prod_start as SOP,
			prod_end as EOP,
			isNull(ForeCastEEIQty,0)as Qty,
			isNull(ForeCastFrozenMaterialCUM,0)as MaterialCostExtended,
			isNull(TransferPriceExtended,0)TransferPriceExtended,
			isNull(SalesForeast,0)as SalesExtended,
			isNull(TransferPriceExtended /nullif(SalesForeast,0),0 )  as TransferPricePercent,
			isNull(ForeCastFrozenMaterialCUM/nullif(SalesForeast,0),0) as MaterialCostPercent
into		#SalesandForecast
from		#PartCalendar
join		part_eecustom on #PartCalendar.Part = part_eecustom.part
left join	#Forecast on #PartCalendar.RequirementMonth = #Forecast.RequirementMonth and #PartCalendar.Part = #Forecast.Part

select	Company,
		Left(BasePart,3) as Customer,
		BasePart,
		Part,
		TwoMonthsPriorQty = COALESCE((Select sum(Qty) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof2priormonth), 0),
		TwoMonthsPriorSales = COALESCE((Select sum(SalesExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof2priormonth), 0),
		TwoMonthsPriorTransferExt = COALESCE((Select sum(TransferPriceExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof2priormonth), 0),
		TwoMonthsPriorMaterialExt = COALESCE((Select sum(MaterialCostExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof2priormonth), 0),
		
		OneMonthsPriorQty = COALESCE((Select sum(Qty) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof1priormonth), 0),
		OneMonthsPriorSales = COALESCE((Select sum(SalesExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof1priormonth), 0),
		OneMonthsPriorTransferExt = COALESCE((Select sum(TransferPriceExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof1priormonth), 0),
		OneMonthsPriorMaterialExt = COALESCE((Select sum(MaterialCostExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayof1priormonth), 0),
		
		CurrentMonthQty = COALESCE((Select sum(Qty) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth ), 0),
		CurrentMonthSales = COALESCE((Select sum(SalesExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth ), 0),
		CurrentMonthTransferExt = COALESCE((Select sum(TransferPriceExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth ), 0),
		CurrentMonthMaterialExt = COALESCE((Select sum(MaterialCostExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth ), 0),
		
		Month1Qty = COALESCE((Select sum(Qty) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth1), 0),
		Month1Sales = COALESCE((Select sum(SalesExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth1), 0),
		Month1TransferExt = COALESCE((Select sum(TransferPriceExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth1), 0),
		Month1MaterialExt = COALESCE((Select sum(MaterialCostExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth1), 0),
		
		Month2Qty = COALESCE((Select sum(Qty) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth2), 0),
		Month2Sales = COALESCE((Select sum(SalesExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth2), 0),
		Month2TransferExt = COALESCE((Select sum(TransferPriceExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth2), 0),
		Month2MaterialExt = COALESCE((Select sum(MaterialCostExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth2), 0),
		
		Month3Qty = COALESCE((Select sum(Qty) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth3), 0),
		Month3Sales = COALESCE((Select sum(SalesExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth3), 0),
		Month3TransferExt = COALESCE((Select sum(TransferPriceExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth3), 0),
		Month3MaterialExt = COALESCE((Select sum(MaterialCostExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth3), 0),
		
		Month4Qty = COALESCE((Select sum(Qty) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth4), 0),
		Month4Sales = COALESCE((Select sum(SalesExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth4), 0),
		Month4TransferExt = COALESCE((Select sum(TransferPriceExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth4), 0),
		Month4MaterialExt = COALESCE((Select sum(MaterialCostExtended) from #SalesandForecast SF2 where SF2.Part = PartList.Part and SF2.Company = PartList.Company and ReqMonth = @firstdayofcurrentmonth4), 0)
		
from	(Select distinct	Company,
							BasePart,
							Part
			from			#PartCalendar) PartList
order by 1,2,3

End		


GO
