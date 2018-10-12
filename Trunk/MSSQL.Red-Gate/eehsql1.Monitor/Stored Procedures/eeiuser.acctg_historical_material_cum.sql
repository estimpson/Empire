SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [eeiuser].[acctg_historical_material_cum] (@part varchar(50))
as


-- exec eeiuser.acctg_historical_material_cum 'TXL-18-BK'


--declare @part varchar(50)
--select @part = '7158-3032-60'

declare @history  table (part varchar(50), from_date datetime, from_material_cum decimal(18,6), to_date datetime, to_material_cum decimal(18,6))
declare @history2 table (part varchar(50), from_date datetime, from_material_cum decimal(18,6), to_date datetime, to_material_cum decimal(18,6))
declare @history3 table (part varchar(50), from_date datetime, from_material_cum decimal(18,6), to_date datetime, to_material_cum decimal(18,6))

insert into @history

select a1.part,a1.time_stamp,  a1.material_cum, a2.time_stamp, a2.material_cum
from (select row_number () over (order by time_stamp) as R_NUM, time_stamp, part, material_cum from part_standard_historical_daily where part = @part) a1
join (select row_number () over (order by time_stamp) as R_NUM, time_stamp, part, material_cum from part_standard_historical_daily where part = @part) a2
on a1.R_NUM = a2.R_NUM+1
where a1.part = a1.part
and a1.material_cum <> a2.material_cum

--select * from @history

declare @tran_count int
select @tran_count = (select count(*) from @history)

--select @tran_count

if @tran_count < 1
begin

insert into @history2
select part, time_stamp, material_cum, getdate(), material_cum from part_standard_historical_daily where part = @part 
and time_stamp = (select min(time_stamp) from part_standard_historical_daily where part = @part)
end
else
begin
insert into @history2
select part, time_stamp, material_cum, getdate(), material_cum from part_standard_historical_daily where part = @part
and time_stamp = (select min(time_stamp) from part_standard_historical_daily where part = @part)
update @history2 set to_date = a.from_date, to_material_cum = a.to_material_cum from @history2 b join
@history a on a.part = b.part where a.from_date in (select min(from_date) from @history)
insert into @history3
select part, getdate(), material_cum, time_stamp, material_cum from part_standard_historical_daily where part = @part
and time_stamp = (select max(time_stamp) from part_standard_historical_daily where part = @part)
update @history3 set from_date = a.from_date, from_material_cum = a.from_material_cum from @history2 b join
@history a on a.part = b.part where a.from_date in (select max(from_date) from @history)


end

select a1.part, a2.from_date,  a1.from_date as to_date, a2.from_material_cum as material_cum
-- a1.R_NUM, a1.part, a1.from_date, a1.from_material_cum, a1.to_date, a1.to_material_cum, a2.R_NUM, a2.from_date, a2.from_material_cum, a2.to_date
from (select row_number () over (order by from_date) as R_NUM, part, from_date, from_material_cum, to_date, to_material_cum from @history) a1
join (select row_number () over (order by from_date) as R_NUM, part, from_date, from_material_cum, to_date, to_material_cum from @history) a2
on a1.R_NUM = a2.R_NUM+1
where a1.part = a1.part
and a1.from_material_cum != a2.from_material_cum 
union
select part, from_date, to_date, from_material_cum as material_cum from @history2
union
select part, from_date, to_date, from_material_cum as material_cum from @history3



GO
