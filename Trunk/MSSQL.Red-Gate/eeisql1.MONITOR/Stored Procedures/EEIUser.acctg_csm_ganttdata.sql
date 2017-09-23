SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_csm_ganttdata] 

-- Created by: DW 2016-10-11 9:00 pm
-- This procedure populates tables used by evision/empireweb/salesforecastbyvehiclegannt.aspx


as

declare @temp table (id int, OrderID int, ParentID int,  vehicle varchar(500), empire_market_subsegment varchar(250), base_part varchar(25), Title varchar(500),summary bit)

insert into @temp
select							row_number() over (order by vehicle, empire_market_subsegment, base_part) as ID,
								row_number() over (partition by vehicle, empire_market_subsegment order by base_part) as OrderID,
								rank() over (order by vehicle, empire_market_subsegment) as ParentID,			
								vehicle,
								empire_market_subsegment,
								base_part,
								(case when (Grouping(base_part) = 1) then empire_market_subsegment else base_part end) as Title,
								(CASE WHEN (GROUPING(base_part) =1) THEN 1 ELSE 0 end) as summary
                                
                                from eeiuser.acctg_csm_vw_select_sales_forecast
                                
                                 group by vehicle, empire_market_subsegment, base_part with rollup
	                             having (sum(Total_2014_Totaldemand)+sum(Total_2015_Totaldemand)+sum(Total_2016_TotalDemand)+sum(Total_2017_TotalDemand)+sum(Total_2018_TotalDemand)+sum(TOTAL_2019_TotalDemand)+sum(Cal20_TotalDemand)+sum(Cal21_TotalDemand))>0
                                 order by vehicle, empire_market_subsegment, base_part

delete from eeiuser.acctg_csm_gantttasks

insert into eeiuser.acctg_csm_gantttasks
select id, (case when parentid=id then null else parentid end) as parentid, 
orderid, 
a.vehicle, 
a.empire_market_subsegment, 
a.base_part, 
(case when summary = 1 then a.title else a.title+' - '+b.name end) as Title, 
(case when summary = 1 then isnull(c.subsegmentSOP,'2000-01-01') else isnull(b.sop,'2000-01-01') end) as Start, 
(case when summary = 1 then isnull(c.subsegmentEOP,'2000-01-01') else isnull(b.eop,'2020-12-31') end) as 'End', 
0 as PrecentComplete, 
1 as expanded, 
summary 
from @temp a 
left join (select vehicle, max(empire_application) as name, base_part, min(sop) as SOP, max(eop) as EOP from eeiuser.acctg_csm_vw_select_sales_forecast group by vehicle, base_part) b 
on a.vehicle = b.vehicle and a.base_part = b.base_part
left join (select vehicle, empire_market_subsegment, min(sop) as subsegmentSOP, max(eop) as subsegmentEOP from eeiuser.acctg_csm_vw_select_sales_forecast group by vehicle, empire_market_subsegment) c
on a.vehicle = c.vehicle and a.empire_market_subsegment = c.empire_market_subsegment
--where task is not null and vehicle is not null
order by vehicle, sop, base_part, id

delete eeiuser.acctg_csm_ganttdependencies

insert into eeiuser.acctg_csm_GanttDependencies
select id,  id-1 as PredecessorID,  id+1 as SuccessorID, -1 as Type 
from @temp a 
left join (select base_part, min(sop) as SOP, max(eop) as EOP from eeiuser.acctg_csm_vw_select_sales_forecast group by base_part) b
on a.base_part = b.base_part
--where task is not null and vehicle is not null
order by id



--ID, ID of predecessor, ID of successor, type = FS, SS, FF, SF
--Task = Regular Task, Summary, Milestone


-- select * from eeiuser.acctg_csm_gantttasks where title is not null



GO
