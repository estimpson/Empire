SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create view [HN].[VW_TiempoMuerto_Areas]
as
Select	AreaCargada = AreaCargada.Area,
		Modulo = Modulo.Area,
		log_machine,
		log_activities,
		log_operator,
		log_date_begin,
		log_date_end,
		log_numberPart,
		Molde = Moldes.Nombre,
		TiempoMuertoMinutos = DATEDIFF(MINUTE,log_date_begin, log_date_end)
from	eeh.hn.General_Log_DownTime DownTime
	inner join sistema.dbo.SA_Areas AreaCargada
		on DownTime.log_areaID = AreaCargada.AreaId
	inner join sistema.dbo.SA_Areas Modulo
		on DownTime.log_AssignedArea = Modulo.AreaId
	left join sistema.dbo.MD_Moldes Moldes
		 on DownTime.log_MoldeID = Moldes.MoldeID
where	log_date_save>='2016-01-01'

GO
