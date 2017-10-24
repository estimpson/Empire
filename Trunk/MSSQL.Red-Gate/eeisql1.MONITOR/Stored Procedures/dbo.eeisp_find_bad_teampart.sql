SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[eeisp_find_bad_teampart]
as begin
select distinct basepart 
into #sales
from vw_eei_sales_forecast  

select distinct basepart 
into #sales2
from vw_eei_sales_history


select  distinct substring(part,1,7) as basepart , team_no 
into #partlist
from part_eecustom where  part in (select distinct part from #sales) or part in (select distinct part from #sales2)

select count(team_no),  basepart
from #partlist
group by basepart
having count(team_no) >1


end

GO
