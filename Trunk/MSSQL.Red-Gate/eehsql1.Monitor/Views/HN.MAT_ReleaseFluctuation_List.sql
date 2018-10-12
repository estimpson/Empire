SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [HN].[MAT_ReleaseFluctuation_List] as 
--Contenedor 1
select	Week = FechaEEH, Operation.*
from	(
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = FechaEEH,
		Qty = Sum(Futuros.Contenedor1),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	--Contenedor 2
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = Dateadd(d, 7, FechaEEH),
		Qty = Sum(Futuros.Contenedor2),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	--Contenedor 3
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = Dateadd(d, 7*2, FechaEEH),
		Qty = Sum(Futuros.Contenedor3),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	--Contenedor 4
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = Dateadd(d, 7*3, FechaEEH),
		Qty = Sum(Futuros.Contenedor4),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	--Contenedor 5
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = Dateadd(d, 7*4, FechaEEH),
		Qty = Sum(Futuros.Contenedor5),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	--Contenedor 5
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = Dateadd(d, 7*5, FechaEEH),
		Qty = Sum(Futuros.Contenedor6),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	--Contenedor 7
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = Dateadd(d, 7*6, FechaEEH),
		Qty = Sum(Futuros.Contenedor7),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	--Contenedor 8
	select	ContainerID = Futuros.ContenedorID,
		Part = left(Futuros.Part,7),
		Container = Dateadd(d, 7*7, FechaEEH),
		Qty = Sum(Futuros.Contenedor8),
		Type = 'F'
	from	Sistema.dbo.CP_Contenedores_Futuros Futuros
		join Sistema.dbo.CP_Contenedores Containers on Containers.ContenedorID = Futuros.ContenedorID
	group by Futuros.ContenedorID,left(Part,7),Containers.FechaEEH
	union
	select	ContainerID = Containers.ContenedorID,
		part = left(Part,7), 
		Container, 
		Qty = -sum(Quantity),
		Type = 'S'
	from	eeh.dbo.audit_trail audit_trail
		join (	select	shipper = convert(varchar,id), 
				Container = convert(datetime, floor(convert(float,dateadd( d, 8-datepart(dw,date_shipped),date_shipped))))
			from	eeh.dbo.shipper shipper
			where	shipping_dock like 'PASO%'
				or shipping_dock like 'TRANH%' ) Shippers on Shippers.shipper = audit_trail.shipper
		join Sistema.dbo.CP_Contenedores Containers on Containers.FechaEEH = Shippers.Container
	where	type = 'S'
		and part <> 'PALLET'
	group by left(part,7), Containers.ContenedorID, Container ) Operation  
    join sistema.dbo.cp_Contenedores Containers on Operation.ContainerID = Containers.ContenedorID
GO
