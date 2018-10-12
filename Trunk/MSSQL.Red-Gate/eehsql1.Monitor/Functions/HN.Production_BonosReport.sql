SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [HN].[Production_BonosReport](	@CantidadBono int)
returns @Reporte table
	(   Tipo varchar(15),
	    part varchar(25),
	    Revision int,
	    Lunes numeric(20,6),
	    Martes numeric(20,6),
	    Miercoles numeric(20,6),
	    Jueves numeric(20,6),
	    Viernes numeric(20,6),
	    Sabado numeric(20,6))
as 
begin

declare	@ProduccionAsignacion table
	(   Tipo varchar(15),
	    part varchar(25),
	    Revision int,
	    Lunes numeric(20,6),
	    Martes numeric(20,6),
	    Miercoles numeric(20,6),
	    Jueves numeric(20,6),
	    Viernes numeric(20,6),
	    Sabado numeric(20,6),
	    primary key (part, tipo )  )

declare	@Balance table
	(   Part varchar(25),
	    Lunes numeric(20,6),
	    Martes numeric(20,6),
	    Miercoles numeric(20,6),
	    Jueves numeric(20,6),
	    Viernes numeric(20,6),
	    Sabado numeric(20,6),
	    primary key (part))
	    
insert into @ProduccionAsignacion( Tipo, Part, Revision,
	Lunes, Martes, Miercoles, Jueves, Viernes, Sabado)
select	Tipo, Part, Revision,
	Lunes, Martes,Miercoles, 
	Jueves,Viernes,Sabado
from	(
	select	Tipo = '1.Distribucion',
		Asignacion.Part,
		Asignacion.Revision, 
		Lunes = Asignacion.ProgramadoDia1,
		Martes = Asignacion.ProgramadoDia2,
		Miercoles = Asignacion.ProgramadoDia3,
		Jueves = Asignacion.ProgramadoDia4,
		Viernes = Asignacion.ProgramadoDia5,
		Sabado = Asignacion.ProgramadoDia6
	from	sistema.dbo.cp_revisiones_produccion_asignacion Asignacion
		join sistema.dbo.cp_contenedores Contenedores on Asignacion.ContenedorID = Contenedores.ContenedorID
	where	Contenedores.Activo = 1

	union all

	select	Tipo = '2.Produccion',
		Part = PartProduced,
		Revision = 0,
		Lunes = sum(case when datepart(dw, TranDT) = 2 then -QtyProduced else 0 end),
		Martes = sum(case when datepart(dw, TranDT) = 3 then -QtyProduced else 0 end),
		Miercoles = sum(case when datepart(dw, TranDT) = 4 then -QtyProduced else 0 end),
		Jueves = sum(case when datepart(dw, TranDT) = 5 then -QtyProduced else 0 end),
		Viernes = sum(case when datepart(dw, TranDT) = 6 then -QtyProduced else 0 end),
		Sabado = sum(case when datepart(dw, TranDT) = 7 then -QtyProduced else 0 end)
	from	sistema.dbo.cp_revisiones_produccion_asignacion Asignacion
		join Sistema.dbo.cp_contenedores Contenedores on Contenedores.ContenedorID = Asignacion.ContenedorID
		left join BackFlushHeaders on Asignacion.Part = BackFlushHeaders.PartProduced and trandt >= Dateadd(d,-7,Contenedores.FechaEEH)
	where	activo = 1
	group by PartProduced ) x
where	part is not null
order by part, Tipo


insert into @Balance(Part, Lunes,Martes, Miercoles, Jueves, Viernes, Sabado)
select	Part,
	Lunes = Sum(Lunes), Martes = sum(Martes), Miercoles = sum(Miercoles), 
	Jueves = sum(Jueves),Viernes = sum(Viernes), Sabado = sum(Sabado)
from	@ProduccionAsignacion
group by part



declare	@Bono table
	(   Part varchar(25),
	    Lunes numeric(20,6),
	    Martes numeric(20,6),
	    Miercoles numeric(20,6),
	    Jueves numeric(20,6),
	    Viernes numeric(20,6),
	    Sabado numeric(20,6),
	    primary key (part))
	
insert into @bono(Part, Lunes,Martes, Miercoles, Jueves, Viernes, Sabado)
select	Asignacion.Part,
	Lunes = case when Asignacion.Lunes > 0 and Balance.Lunes < 0 then @CantidadBono else 0 end,
	Martes = case when Asignacion.Martes > 0 and Balance.Martes < 0 then @CantidadBono else 0 end,
	Miercoles = case when Asignacion.Miercoles > 0 and Balance.Miercoles < 0 then @CantidadBono else 0 end,
	Jueves = case when Asignacion.Jueves > 0 and Balance.Jueves < 0 then @CantidadBono else 0 end,
	Viernes = case when Asignacion.Viernes > 0 and Balance.Viernes < 0 then @CantidadBono else 0 end,
	Sabado = case when Asignacion.Sabado > 0 and Balance.Sabado < 0 then @CantidadBono else 0 end
from	(   select * 
    	    from @ProduccionAsignacion 
    	    where Tipo = '1.Distribucion' ) Asignacion
	join (	select * 
	      	from @ProduccionAsignacion 
	      	where Tipo = '2.Produccion') Produccion on Asignacion.Part = Produccion.Part
	join @Balance Balance on Balance.part = Asignacion.part

insert into @Reporte( Tipo, Revision, Part,
	Lunes, Martes, Miercoles, Jueves, Viernes, Sabado)
select	Tipo,
	Revision,
	Part,
	Lunes, Martes, Miercoles, Jueves, Viernes, Sabado
from	(
	select	Tipo,
		Revision,
		Part,
		Lunes, Martes, Miercoles, Jueves, Viernes, Sabado
	from	@ProduccionAsignacion

	union all
	select	Tipo = '3.Balance',
		Revision = 0,
		Part,
		Lunes, Martes, Miercoles, Jueves, Viernes, Sabado
	from	@Balance 
	union all
	select	Tipo = '4.Autorizacion',
		Revision = 0,
		Part,
		Lunes=0, Martes=0, Miercoles=0, Jueves=0, Viernes=0, Sabado=0
	from	@Balance 

	union all
	select	Tipo = '5.Bono',
		Revision = 0,
		Part,
		Lunes, Martes, Miercoles, Jueves, Viernes, Sabado
	from	@bono bono ) x
order by part, tipo

return
end
GO
