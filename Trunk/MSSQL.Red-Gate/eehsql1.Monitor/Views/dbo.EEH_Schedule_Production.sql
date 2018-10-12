SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_Schedule_Production] as
select	Container = FechaEEH,
	Part, QtySchedule = case revisionActual 
			    when 1 then revision1
			    when 2 then revision2
			    when 3 then revision3
			    else 0 end
from	Sistema.dbo.CP_Revisiones_Produccion Produccion
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Produccion.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 1, FechaEEH),
	Part, QtySchedule = Contenedor2
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 2, FechaEEH),Part, QtySchedule = Contenedor3
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 3, FechaEEH),Part, QtySchedule = Contenedor4
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 4, FechaEEH),Part, QtySchedule = Contenedor5
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 5, FechaEEH),Part, QtySchedule = Contenedor6
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 6, FechaEEH),Part, QtySchedule = Contenedor7
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 7, FechaEEH),Part, QtySchedule = Contenedor8
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
	
union all
select	Container = Dateadd(wk, 8, FechaEEH),Part, QtySchedule = Contenedor9
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 9, FechaEEH),Part, QtySchedule = Contenedor10
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 10, FechaEEH),Part, QtySchedule = Contenedor11
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 11, FechaEEH),Part, QtySchedule = Contenedor12
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 12, FechaEEH),Part, QtySchedule = Contenedor13
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 13, FechaEEH),Part, QtySchedule = Contenedor14
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 14, FechaEEH),Part, QtySchedule = Contenedor15
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 15, FechaEEH),Part, QtySchedule = Contenedor16
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 16, FechaEEH),Part, QtySchedule = Contenedor17
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 17, FechaEEH),Part, QtySchedule = Contenedor18
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 18, FechaEEH),Part, QtySchedule = Contenedor19
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 19, FechaEEH),Part, QtySchedule = Contenedor20
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
union all
select	Container = Dateadd(wk, 20, FechaEEH),Part, QtySchedule = Contenedor21
from	Sistema.dbo.CP_Contenedores_Futuros Futuros
	join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Futuros.ContenedorID
where	Contenedores.Activo = 1
	
GO
