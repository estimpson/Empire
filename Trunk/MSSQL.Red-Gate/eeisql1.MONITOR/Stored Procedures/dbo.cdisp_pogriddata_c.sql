SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[cdisp_pogriddata_c]
as
select mps.part,
  due=convert(datetime,(dateadd(dd,(case datepart(dw,mps.due)
  when 1 then 2
  when 2 then 0
  when 3 then-1
  when 4 then-2
  when 5 then-3
  when 6 then-4
  when 7 then-5
  end),mps.due)),101),
  quantity=sum(mps.qnty)
  from master_prod_sched as mps join
  part as p on p.part=mps.part
  where mps.type='P'
  group by mps.part,mps.due order by
  1 asc,2 asc
  
GO
