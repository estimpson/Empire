SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_rpt_badReceipts] (@startdate datetime)

as

begin

select   convert(datetime,date_stamp),serial, type, part,quantity, price,cost, (quantity*cost) as extcost,posted
from audit_trail 
where type = 'R' and 
date_stamp > @startdate and 
serial not in (select serial from object) and 
serial not in (Select serial from audit_trail where date_stamp > @startdate  and type <>'R')

union all

select   convert(datetime, date_stamp),serial, type, part,quantity, price,cost, (quantity*cost) as extcost, posted
from audit_trail 
where serial in (Select serial from audit_trail where type = 'R' and date_stamp > @startdate group by serial having count(2) > 1) 

End
GO
