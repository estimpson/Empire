
/*
Create (EEH) View.Monitor.TOPS.EEH_Capacity.sql
*/

use Monitor
go

--drop table TOPS.EEH_Capacity
if	objectproperty(object_id('TOPS.EEH_Capacity'), 'IsView') = 1 begin
	drop view TOPS.EEH_Capacity
end
go

create view TOPS.EEH_Capacity
as
select
	BasePart = Data.Part
,	CapacityPerHour = max(CapacidadInstaladaPorHora)
,	ProductionCoordinator = max(CoordinadorProduccion)
,	AssociatedLine = case
							 when max(Asociacion_Parte) is null then
								 ''
							 else
								 max(Asociacion_Parte)
						 end
,	IsPremium = case when max(convert(int, IsPremium)) = 1 then 'Yes' else 'No' end
,	TransactionDT = max(Data.TransactionDT)
,	BottleNeck = CapacidadMinima.CuelloBotella
from
(
	select
		Part = spp.Part
	,	CapacidadInstaladaPorHora = min(convert(
												   numeric(10)
											   ,   3600 / (sppt.Trabajo + sppt.Desperdicio + sppt.Transporte)
												   * sppt.Personal
											   )
									   )
	,	TransactionDT = max(sppt.TransactionDT)
	from
		Sistema.dbo.SA_PartProcesos as spp
		inner join Sistema.dbo.SA_Procesos as sp
			on spp.ProcesoID = sp.ProcesoID
		inner join Sistema.dbo.SA_PartProcessTime as sppt
			on sppt.PPID = spp.ID
	where
		(sp.Status = 1)
		and (sppt.Trabajo + sppt.Desperdicio + sppt.Transporte) <> 0
		and sppt.Personal <> ''
	group by
		Part
) as Data
	left join Sistema.dbo.SA_Partes SAP
		on left(Data.Part, len(Data.Part)) = left(SAP.Part, len(Data.Part))
	left join Sistema.dbo.CP_Asociacion_Partes ASP
		on Data.Part = ASP.Parte
	left join eeh.HN.VW_CapacidadLineas_Ensambles CapacidadMinima
		on CapacidadMinima.Linea = replace(Data.Part, 'PRE-', '')
group by
	Data.Part
,	CapacidadMinima.CuelloBotella
go

select
	*
from
	TOPS.EEH_Capacity
order by
	BasePart