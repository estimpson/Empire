SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---- exec dbo.rep_consulta_produccion_moldeo '7/7/2008','7/10/2008'
CREATE procedure [dbo].[rep_consulta_produccion_moldeo] 
@fecha_del datetime,
@fecha_al datetime as

select fecha,circuito,machine,sum(cantidad) cantidad, isnull(produced,0) produced
from
(
select distinct programado.fecha, programado.circuito, programado.machine,shift,
programado.cantidad,(select sum(qtyproduced) qtyproduced
						from eeh.dbo.backflushheaders a
						join eeh.dbo.audit_trail b on b.serial = a.serialproduced and b.type = 'J'
						join eeh.dbo.wodetails c on c.id = a.wodid
						join eeh.dbo.woheaders d on d.id = c.woid 
						where programado.Machine = d.Machine and
							programado.Circuito = a.partproduced and
							datediff( d,programado.fecha,b.date_stamp) = 0) produced
from eeh.dbo.cp_produccion_maquina programado
---join sistema.dbo.cp_contenedores cpc on cpc.contenedorid = programado.contenedorid
where area = 3
---and programado.machine = 'md-27'
) t
where fecha between @fecha_del and @fecha_al
group by fecha, circuito, machine,isnull(produced,0)
having sum(cantidad) > 0
order by 3,2,1

--
--select * from backflushheaders
--where partproduced = '1012404-WA00'

--1192.000000
--3652.000000
--4062.000000

GO
