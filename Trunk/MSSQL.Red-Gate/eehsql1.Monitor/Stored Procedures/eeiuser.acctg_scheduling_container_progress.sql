SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [eeiuser].[acctg_scheduling_container_progress] @ContainerWeek int

-- exec eeiuser.acctg_scheduling_container_progress '778'

as 

declare @end_date date
select @end_date = (select dateadd(d,+1,fechaEEH) from sistema.dbo.CP_Contenedores where activo=1)

declare @begin_date date
select @begin_date = dateadd(d,-7,@end_date)

select	contenedorID 
		,category = case when ltrim(rtrim(isnull(materialcritico,'')))<>'' then 'Critical Material' else (case when left(right(a.part,len(a.part)-charindex('-',a.part,1)),2)='PT' then 'Prototypes' else 'Production' end) end
		,a.part 
		,comentario1
		,LTRIM(RTRIM(isnull(materialcritico,''))) as materialcritico 
		,revision1 = isnull(revision1,0)
		,revision3 = isnull(revision3,0)
		,EEH_adjustment = isnull(revision3,0) - isnull(revision1,0)
		,EEH_percentage_adjustment = case when isnull(revision1,0) = 0 then 0 else isnull(revision3,0)/revision1 end 
		,qty_built = isnull(b.qty_built,0)
		,percent_complete = case when isnull(revision3,0) = 0 then 0 else isnull(b.qty_built,0)/revision3 end

from sistema.dbo.CP_Revisiones_Produccion a

left join 

(select at.part, sum(quantity) as qty_built from audit_trail at
join part p 
on at.part = p.part 
where date_stamp >= @begin_date and date_stamp < @end_date and at.type = 'J' and p.type = 'F'
group by at.part ) b

on a.part = b.part
where a.contenedorID = @containerweek
order by category asc, materialcritico, left(a.part,3) asc, percent_complete asc



--select	contenedorID 
--		,category = case when ltrim(rtrim(isnull(materialcritico,'')))<>'' then 'Critical Material' else (case when left(right(a.part,len(a.part)-charindex('-',a.part,1)),2)='PT' then 'Prototypes' else 'Production' end) end
--		,a.part 
--		,comentario1
--		,LTRIM(RTRIM(isnull(materialcritico,''))) as materialcritico 
--		,revision1
--		,revision3
--		,EEH_adjustment = isnull(revision3,0) - isnull(revision1,0)
--		,EEH_percentage_adjustment = case when isnull(revision1,0) = 0 then 0 else isnull(revision3,0)/revision1 end 
--		,unapproved_qoh = isnull(b.total_qoh,0) - isnull(c.available_qoh,0)
--		,qty_remaining_to_build = isnull(a.revision3,0)-isnull(b.total_qoh,0)
--		,percent_built = case when isnull(revision3,0) = 0 then 0 else isnull(b.total_qoh,0)/revision3 end		
--		,approved_qoh = isnull(c.available_qoh,0)
--		,qty_remaining_to_approve = isnull(a.revision3,0) - isnull(c.available_qoh,0) - (isnull(a.revision3,0)-isnull(b.total_qoh,0))
--		,percent_complete = case when isnull(revision3,0) = 0 then 0 else isnull(c.available_qoh,0)/revision3 end

--from sistema.dbo.CP_Revisiones_Produccion a

--left join 

--(	select	o.part, sum(quantity) as total_qoh from object o join part p on o.part = p.part 
--	where	p.type = 'F' and user_defined_status <> 'PRESTOCK'  
--	group by o.part) b

--on a.part = b.part

--left join 

--(select o.part, sum(quantity) as available_qoh from object o join part p on o.part = p.part join location l on o.location = l.code 
--where p.type = 'F' and user_defined_status <> 'PRESTOCK' and o.status = 'A' and (ISNULL(l.secured_location,'N') = 'N' or o.location ='Shipping' or o.location like '%Left%' or o.location like '%TRAN%')
--group by o.part
----order by o.part
--) c

--on a.part = c.part

--where a.contenedorID = @containerweek
--order by category asc, materialcritico, left(a.part,3) asc, percent_complete asc

GO
