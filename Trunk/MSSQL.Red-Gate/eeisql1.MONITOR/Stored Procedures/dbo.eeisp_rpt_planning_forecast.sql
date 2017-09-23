SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


CREATE procedure	[dbo].[eeisp_rpt_planning_forecast]
as
Begin

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
from			[dbo].[fn_Calendar_StartCurrentMonth] (Null,'mm',1,12)
where		EntryDT >= FT.fn_TruncDate('mm', getdate())

Create table	#BasePartList (	BasePart varchar(25)
							Primary Key ( BasePart	))
Insert	#BasePartList (BasePart
					 )
Select	 distinct left(part,7)
from		part
Where	part.type = 'F'
UNION
Select	 distinct left(part,7)
from		[ES3_bk].[dbo].part part
Where	part.type = 'F'

Create table	#MonthlySales (	Team varchar(25),
							MonthDT datetime,
							BasePart  varchar(25),
							Qty numeric (20,6),
							Price numeric(20,6),
							Extended numeric (20,6), Primary Key (MonthDT, BasePart) )
Insert	#MonthlySales (	Team,
						MonthDT,
						BasePart,
						Qty,
						Price,
						extended	 )

Select	max(team),
		ft.fn_truncdate('mm',(CASE WHEN date_due <= getdate() then Getdate() ELSE date_due END)),
		basepart,
		sum(qty_projected),
		sum(qty_projected*price)/nullif(sum(qty_projected),0),
		sum(Extended)
From	vw_eei_sales_forecast
where	date_due >= dateadd(wk,-4,getdate()) 
group by	ft.fn_truncdate('mm',(CASE WHEN date_due <= getdate() then Getdate() ELSE date_due END)),
		basepart
order by 3,2


Create table	#MonthlySalesHist (	Team varchar(25),
								MonthDT datetime,
								BasePart varchar(25),
								Qty numeric (20,6),
								Price numeric(20,6),
								Extended numeric (20,6), Primary Key (MonthDT, BasePart) )
Insert	#MonthlySalesHist (	Team,
							MonthDT,
							BasePart,
							Qty,
							Price,
							extended	 )

Select	max(team),
		ft.fn_truncdate('mm',(CASE WHEN date_shipped <= getdate() then Getdate() ELSE date_shipped END)),
		basepart,
		sum(qty_shipped),
		sum(qty_shipped*price)/nullif(sum(qty_shipped),0),
		sum(Extended)
From	vw_eei_sales_history
where	date_shipped>= ft.fn_truncdate('mm',getdate()) and date_shipped< dateadd(mm,1,ft.fn_truncdate('mm',getdate())) 
group by	ft.fn_truncdate('mm',(CASE WHEN date_shipped <= getdate() then Getdate() ELSE date_shipped END)),
		basepart
order by 3 ,2

Declare	@ForeCastID varchar(50)
Select	@ForeCastID =  convert(varchar(25),datepart(yy, getdate()))+ '/' +RIGHT(REPLICATE('0', abs(datalength(convert(varchar(25),datepart(mm, getdate())))-2)) + convert(varchar(25),datepart(mm, getdate())),2) + '/' + RIGHT(REPLICATE('0', abs(datalength(convert(varchar(25),datepart(dd, getdate())))-2)) + convert(varchar(25),datepart(dd, getdate())),2) + ' PSF'

--Delete	eeiuser.sales_1
--where	forecast_name = @ForeCastID

--insert	eeiuser.sales_1

Select	@ForeCastID,
		getdate(),
		Coalesce(MonthlySales.team, MonthlySalesHist.team) as Team,
		Left (BasePartList.BasePart, 3),
		BasePartList.BasePart,
		fiscalyear,
		period,
		isNull( MonthlySales.Qty,0) + isNull(MonthlySalesHist.Qty,0) as Qty,
		dbo.fn_Greaterof(Coalesce(isNull( MonthlySales.Price,0),isNull( MonthlySalesHist.Price,0)),Coalesce(isNull( MonthlySalesHist.Price,0),isNull( MonthlySales.Price,0))) as Price,
		isNull( MonthlySales.Extended,0) + isNull(MonthlySalesHist.Extended,0) as Sales
		
		
from		#BasePartList BasepartList
cross join	#MonthlyBuckets MonthlyBuckets
left	join	#MonthlySales MonthlySales on MonthlyBuckets.MonthDT = MonthlySales.MonthDT and MonthlySales.BasePart =  BasepartList.BasePart
left	join	#MonthlySalesHist MonthlySalesHist on MonthlyBuckets.MonthDT = MonthlySalesHist.MonthDT and MonthlySalesHist.BasePart =  BasepartList.BasePart
where	Abs(isNull( MonthlySales.Qty,0)) + abs(isNull(MonthlySalesHist.Qty,0)) >0 
order by 4,5
End

GO
