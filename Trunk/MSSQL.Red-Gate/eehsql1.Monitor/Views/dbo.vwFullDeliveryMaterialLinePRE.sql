SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  view [dbo].[vwFullDeliveryMaterialLinePRE]
as
/*

select	*
from	vwFullDeliveryMaterialLinePRE

*/

select	T.TopPart Linea,
	T.Line,
	T.ChildPart Componente,
	T.Xqty [BOM qty],
	T.Factor Conversion,
	((T.Xqty*T.[Requerido Total])/T.Factor)[Requerimiento Total],
	((T.Xqty*T.[Requerido Acumulado])/T.Factor)[Requerimiento Acumulado],
	((T.Xqty*T.[Requerido Diario])/T.Factor)[Requerimiento del dia],
	T.[Dia a Cargar]
--		T.[Cargado Diario],
--		sum([Cargado Acumulado])[Cargado Acumulado]
from (
	select	TopPart, 
		ChildPart,
		Xqty,
		Line = ltrim(substring(TopPart,5,15)),
		Factor = isnull(Convertion.ConvertionFactor,1),
		[Requerido Total] = case (select isnull((select distinct 1 from FT.XRt x1 where x1.TopPart = Xrt.TopPart and ChildPart like 'MOLD%'),0))
			when 0 then --no tiene MOLD
				case
					when datepart(dw,getdate()) >= 5 then --Jueves en adelante
						isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0)+isnull(Area3.ProgramadoDia3,0)+isnull(Area3.ProgramadoDia4,0)+isnull(Area3.ProgramadoDia5,0)+isnull(Area3.ProgramadoDia6,0)
					else
						isnull(Area.ProgramadoDia1,0)+isnull(Area.ProgramadoDia2,0)+isnull(Area.ProgramadoDia3,0)+isnull(Area.ProgramadoDia4,0)+isnull(Area3.ProgramadoDia5,0)+isnull(Area3.ProgramadoDia6,0)
				end
			else  --si tiene MOLD
				case 
					when datepart(dw,getdate()) >= 4 then --Miercoles en adelante
						isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0)+isnull(Area3.ProgramadoDia3,0)+isnull(Area3.ProgramadoDia4,0)+isnull(Area3.ProgramadoDia5,0)+isnull(Area3.ProgramadoDia6,0)
					else
						isnull(Area.ProgramadoDia1,0)+isnull(Area.ProgramadoDia2,0)+isnull(Area.ProgramadoDia3,0)+isnull(Area.ProgramadoDia4,0)+isnull(Area.ProgramadoDia5,0)+isnull(Area.ProgramadoDia6,0)
				end
			end,
		[Requerido Acumulado] = case (select isnull((select distinct 1 from FT.XRt x1 where x1.TopPart = Xrt.TopPart and ChildPart like 'MOLD%'),0))
			when 0 then --no tiene MOLD
				case datepart(dw,getdate())
					when 2 then isnull(Area.ProgramadoDia1,0)+isnull(Area.ProgramadoDia2,0)+isnull(Area.ProgramadoDia3,0) --Lunes
					when 3 then isnull(Area.ProgramadoDia1,0)+isnull(Area.ProgramadoDia2,0)+isnull(Area.ProgramadoDia3,0)+isnull(Area.ProgramadoDia4,0) --Martes
					when 4 then isnull(Area.ProgramadoDia1,0)+isnull(Area.ProgramadoDia2,0)+isnull(Area.ProgramadoDia3,0)+isnull(Area.ProgramadoDia4,0)+isnull(Area.ProgramadoDia5,0)+isnull(Area.ProgramadoDia6,0)	--Miercoles
					when 5 then isnull(Area3.ProgramadoDia1,0)  --Jueves
					when 6 then isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0) --viernes
					when 7 then isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0) --Sabado
					when 1 then isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0) --Domingo
				end
			else  --si tiene MOLD
				case datepart(dw,getdate())
					when 2 then isnull(Area.ProgramadoDia1,0)+isnull(Area.ProgramadoDia2,0)+isnull(Area.ProgramadoDia3,0)+isnull(Area.ProgramadoDia4,0)	--lunes
					when 3 then isnull(Area.ProgramadoDia1,0)+isnull(Area.ProgramadoDia2,0)+isnull(Area.ProgramadoDia3,0)+isnull(Area.ProgramadoDia4,0)+isnull(Area.ProgramadoDia5,0)+isnull(Area.ProgramadoDia6,0)	--Martes
					when 4 then isnull(Area3.ProgramadoDia1,0) --Miercoles
					when 5 then isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0) --Jueves
					when 6 then isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0)+isnull(Area3.ProgramadoDia3,0) --viernes
					when 7 then isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0)+isnull(Area3.ProgramadoDia3,0)--Sabado
					when 1 then isnull(Area3.ProgramadoDia1,0)+isnull(Area3.ProgramadoDia2,0)+isnull(Area3.ProgramadoDia3,0)--Domingo
				end
			end,
		[Dia a Cargar] = case (select isnull((select distinct 1 from FT.XRt x1 where x1.TopPart = Xrt.TopPart and ChildPart like 'MOLD%'),0))
			when 0 then --no tiene MOLD
				case (Datepart(dw,getdate()))			
					when 2 then 2	--Si es Martes poner Lunes
					when 3 then 3	--Si es Viernes poner Lunes
					when 4 then 4	--Si es Viernes poner Lunes
					when 5 then 6	--Si es Jueves poner Viernes
					when 6 then 1   --Si es Viernes poner Lunes
					when 7 then 1   --Si es Viernes poner Lunes
			end
			end,
		[Requerido Diario] = case (select isnull((select distinct 1 from FT.XRt x1 where x1.TopPart = Xrt.TopPart and ChildPart like 'MOLD%'),0))
			when 0 then --no tiene MOLD
				case datepart(dw,getdate())
					when 2 then isnull(Area.ProgramadoDia3,0) --Lunes
					when 3 then isnull(Area.ProgramadoDia4,0) --Martes
					when 4 then isnull(Area.ProgramadoDia6,0) --Miercoles
					when 5 then isnull(Area3.ProgramadoDia1,0) --Jueves
					when 6 then isnull(Area3.ProgramadoDia2,0) --viernes
					when 7 then isnull(Area3.ProgramadoDia2,0) --Sabado
					when 1 then isnull(Area3.ProgramadoDia2,0) --Domingo
				end
			else  --si tiene MOLD
				case datepart(dw,getdate())
					when 2 then isnull(Area.ProgramadoDia4,0) --lunes
					when 3 then isnull(Area.ProgramadoDia6,0) --Martes
					when 4 then isnull(Area3.ProgramadoDia1,0) --Miercoles
					when 5 then isnull(Area3.ProgramadoDia2,0) --Jueves
					when 6 then isnull(Area3.ProgramadoDia3,0) --viernes
					when 7 then isnull(Area3.ProgramadoDia3,0)--Sabado
					when 1 then isnull(Area3.ProgramadoDia3,0)--Domingo
				end
			end
	from	FT.Xrt Xrt with (READUNCOMMITTED)
			join Part with (READUNCOMMITTED) on Xrt.ChildPart = Part.Part 
			inner join Sistema.dbo.CP_Revisiones_Produccion_Asignacion Area with (READUNCOMMITTED) on Area.Part = Xrt.TopPart
			inner join Sistema.dbo.CP_Contenedores Contenedor with (READUNCOMMITTED) on Contenedor.ContenedorID = Area.ContenedorID
			left join Sistema.dbo.CP_Revisiones_Produccion_Asignacion Area3 with (READUNCOMMITTED) on Area3.Part = Xrt.TopPart and Area3.ContenedorID = Area.ContenedorID+1
			left join PartConvertion Convertion with (READUNCOMMITTED) on Convertion.Part = Xrt.ChildPart
	where	Contenedor.Activo = 1
		and TopPart like 'PRE%'
		and BOMLevel = 1
	) as T
group by T.TopPart,
		T.Line,
		T.ChildPart,
		T.Xqty,
		T.Factor,
		T.[Requerido Total],
		T.[Requerido Acumulado],
		T.[Requerido Diario],		
--		T.[Cargado Diario],
		T.[Dia a Cargar]
GO
