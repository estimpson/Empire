SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [HN].[fn_CrearInfoDashboard_Summary]
(	@SearchWeek	int
,	@Date_Today	datetime
,	@Plant		varchar(3)
,	@Part		varchar(25)
)

/*
	
	SELECT	* FROM	HN.fn_CrearInfoDashboard_Summary(37,NULL,'EEI',NULL)

*/


returns @ReturnData table
(	PartNumber					varchar(25)
,	QtyPartWK					int
,	BoxesWk						int
,	HoursWK						numeric(18,2)
,	OperatorsWK					numeric(18,2)
,	QtyPartToday				int
,	QtyBoxesToday					int
,	HoursToday					numeric(18,2)
,	OperatorsToday				numeric(18,2)
,	QtyPartTomorrow				int
,	QtyBoxesTomorrow				int
,	HoursTomorrow				numeric(18,2)
,	OperatorsTomorrow			numeric(18,2)
)
as 
begin

if @Part=''
begin
	set @Part=NULL
end

IF @Date_Today IS NULL
begin
	set @Date_Today=GETDATE()
end

--if @Plant='' OR @Plant IS NULL
--begin
--	set @Plant='EEI'
--end

if @SearchWeek=0 OR @SearchWeek IS NULL
begin
	set @SearchWeek=DATEPART(WEEK,GETDATE())
end

declare @CurrentYear int
declare @NextYear int
declare @NextWeek int
declare @MaxWeek int

set @CurrentYear= DATEPART(year,@Date_Today)

select @MaxWeek=datepart(week,DATEADD(yy, DATEDIFF(yy, 0, @Date_Today) + 1, -1))
 
select @NextYear= case when @SearchWeek=@MaxWeek then @CurrentYear + 1 else 0 end
select @NextWeek= case when @SearchWeek=@MaxWeek then 1 else @SearchWeek+1 end


declare @XdatapieceRate table
(	Part	varchar(25),
	Acum_SecondsPieceRate numeric(10,2)
)

insert into @XdatapieceRate
SELECT part,Acum_SecondsPieceRate=sum(isnull(PieceRate,6)) 
FROM	HN.SSR_Historial
WHERE  PART IS NOT NULL 
		AND PART<>'' 
		AND (SUBSTRING(PART,1,1)<>'"' AND  SUBSTRING(PART,1,1)<>',' 
		AND  SUBSTRING(PART,1,1)<>'´') 
		AND status not in(0,3) 
GROUP BY part--,PieceRate	


--insert return data
insert @ReturnData
select	FinalData.PartNumber,
		FinalData.NeedSortedWeekly,
		FinalData.NeedSortedBoxesWeekly,
		FinalData.HoursRequiredWeekly,
		FinalData.OperatorsRequiredWeekly,
		FinalData.NeedSortedToday,
		QtyBoxesToday=ceiling(case when FinalData.NeedSortedToday < FinalData.standard_pack then 1 else FinalData.NeedSortedToday / FinalData.standard_pack end),
		HoursRequiredToday=((isnull(FinalData.Acum_SecondsPieceRate,10)*FinalData.NeedSortedToday)/3600),
		OperatorsRequiredToday=((isnull(FinalData.Acum_SecondsPieceRate,10)*FinalData.NeedSortedToday)/3600)/ (7 * case when datepart(hour,@Date_Today) <12 then 1 else 0.5 end),
		FinalData.NeedSortedTomorrow,
		QtyBoxesTomorrow=ceiling(case when FinalData.NeedSortedTomorrow < FinalData.standard_pack then 1 else FinalData.NeedSortedTomorrow / FinalData.standard_pack end),
		HoursRequiredTomorrow=((isnull(FinalData.Acum_SecondsPieceRate,10)*FinalData.NeedSortedTomorrow)/3600),
		OperatorsRequiredTomorrow=((isnull(FinalData.Acum_SecondsPieceRate,10)*FinalData.NeedSortedTomorrow)/3600)/7		
		--,FinalData.Factor
		--,FinalData.Acum_SecondsPieceRate
		--,FinalData.DiasIdeales
from	(
	Select	PartNumber=part_number,
			NeedSortedWeekly=Sum(Sort_needed),
			NeedSortedBoxesWeekly=ceiling(sum(sort_needed  / pi.standard_pack)),
			HoursRequiredWeekly=Sum(Hours_required),
			OperatorsRequiredWeekly=(sum(Hours_required))/35 
			,NeedSortedToday= case when datepart(week,@Date_Today)=@SearchWeek then  								
									ceiling(Sum(Sort_needed)/Factor.DiasIdeales)
								else 0 end * case when datepart(hour,@Date_Today) <12 then 1 else 0.5 end
			,NeedSortedTomorrow=case when datepart(week,@Date_Today)=@SearchWeek then  
										case when datepart(hour,@Date_Today) <12 then
											ceiling(Sum(Sort_needed)/Factor.DiasIdeales) * case when datepart(hour,@Date_Today) <12 then 1 else 0.5 end
										else											
											ceiling((Sum(Sort_needed) -((ceiling(Sum(Sort_needed)/Factor.DiasIdeales) * case when datepart(hour,@Date_Today) <12 then 1 else 0.5 end)))	/ case when (Factor.DiasIdeales-1)=0 then -1 else (Factor.DiasIdeales-1) end)											
										end
									else 0 end
			--,Factor.factor
			,Acum_SecondsPieceRate=max(XdatapieceRate.Acum_SecondsPieceRate)
			,Factor.DiasIdeales
			,pi.standard_pack
	From [dbo].[TemporalDataDashboard] 
	inner join Part_inventory PI on TemporalDataDashboard.part_number = pi.part
	left join @XdatapieceRate XdatapieceRate on XdatapieceRate.Part=part_number
	cross join (( select DiasIdeales=datediff(day,@Date_Today,DATEADD(dd, 7-(DATEPART(dw, @Date_Today)), @Date_Today)) )
						--,Factor=datediff(day,@Date_Today,DATEADD(dd, 7-(DATEPART(dw, @Date_Today)), @Date_Today)) - (case when datepart(hour,@Date_Today) <12 then 0 else 0.5 end) )
			)Factor
	Where  Sort_needed<>0  
			and destination=@Plant 
			and Sort_needed<>0 
			AND week in (@SearchWeek,@NextWeek)
			AND year in (@CurrentYear,@NextYear)
			--AND part_number='MAG0130-HE00' 
	Group By part_number,DiasIdeales,pi.standard_pack
			--Factor.factor,
)FinalData
	
	return
end
GO
