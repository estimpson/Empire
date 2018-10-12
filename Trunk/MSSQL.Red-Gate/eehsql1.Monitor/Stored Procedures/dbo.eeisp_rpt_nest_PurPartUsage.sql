SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure
[dbo].[eeisp_rpt_nest_PurPartUsage](@part varchar(25))
/*
Arguments:
None

Result set:
Purchased Part Data

Description:

Author:
Andre S. Boulanger
Copyright c Empire Electronics, Inc.


Andre S. Boulanger January 25, 2004

Process:

*/
as
begin
  select audit_trail.part,
    qty_used=sum(std_quantity),
    cost_used=sum(std_quantity*cost),
    monthOftransaction=convert(char(4),datepart(yy,date_stamp))+'   '+convert(char(2),datepart(mm,date_stamp)),'Material Issue'
    from audit_trail
    where audit_trail.part=@part
    and audit_trail.date_stamp>dateadd(yy,-1,getdate())
    and audit_trail.type='M'
    group by audit_trail.part,
		convert(char(4),datepart(yy,date_stamp))+'   '+convert(char(2),datepart(mm,date_stamp))
  union select audit_trail.part,
    qty_used=sum(std_quantity),
    cost_used=sum(std_quantity*cost),
    monthOftransaction=convert(char(4),datepart(yy,date_stamp))+'   '+convert(char(2),datepart(mm,date_stamp)),'Scrapped'
    from audit_trail
    where audit_trail.part=@part
    and audit_trail.date_stamp>dateadd(yy,-1,getdate())
    and audit_trail.type='Q'
    and audit_trail.to_loc='S'
    group by convert(char(4),datepart(yy,date_stamp))+'   '+convert(char(2),datepart(mm,date_stamp)),audit_trail.part
end
GO
