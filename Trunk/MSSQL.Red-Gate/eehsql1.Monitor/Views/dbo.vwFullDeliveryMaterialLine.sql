SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vwFullDeliveryMaterialLine]
as
select	T.TopPart Linea,
		T.Line,
		T.ChildPart Componente,
		T.Xqty [BOM qty],
		T.Factor Conversion,
		((T.Xqty*T.[Requerido Total])/T.Factor)[Requerimiento Total],
		((T.Xqty*T.[Requerido Acumulado])/T.Factor)[Requerimiento Acumulado],
		((T.Xqty*T.[Requerido Diario])/T.Factor)[Requerimiento del dia],
		T.[Dia a Cargar],
		[Cargado Diario],
		sum([Cargado Acumulado])[Cargado Acumulado]
from (
	select	TopPart, 
			ChildPart,
			Xqty,
			left(TopPart,len(TopPart)-5) Line,
			isnull(Convertion.ConvertionFactor,1) as Factor,
			(Area.ProgramadoDia1+Area.ProgramadoDia2+Area.ProgramadoDia3+Area.ProgramadoDia4+Area.ProgramadoDia5+Area.ProgramadoDia6)[Requerido Total],--total de la semana
			case (Datepart(dw,getdate()))			
				when 2 then Area.ProgramadoDia1	--lunes
				when 3 then Area.ProgramadoDia1+Area.ProgramadoDia2	--martes
				when 4 then Area.ProgramadoDia1+Area.ProgramadoDia2+Area.ProgramadoDia3	--miercoles
				when 5 then Area.ProgramadoDia1+Area.ProgramadoDia2+Area.ProgramadoDia3+Area.ProgramadoDia4	--jueves
				when 6 then Area.ProgramadoDia1+Area.ProgramadoDia2+Area.ProgramadoDia3+Area.ProgramadoDia4+Area.ProgramadoDia5	--viernes
				when 7 then Area.ProgramadoDia1+Area.ProgramadoDia2+Area.ProgramadoDia3+Area.ProgramadoDia4+Area.ProgramadoDia5+Area.ProgramadoDia6	--sabado
			end [Requerido Acumulado],--acumulado de la semana
			case (Datepart(dw,getdate()))			
				when 2 then 'MARTES'--lunes
				when 3 then 'MIERCOLES'	--martes
				when 4 then 'JUEVES'	--miercoles
				when 5 then 'VIERNES'	--jueves
				when 6 then isnull(case Area.ProgramadoDia6
							 		when 0 then 'LUNES'
									else 'SABADO'
									end,0)
				when 7 then	'LUNES'
			end [Dia a Cargar],
			case (Datepart(dw,getdate()))			
				when 2 then Area.ProgramadoDia2	--lunes
				when 3 then Area.ProgramadoDia3	--martes
				when 4 then Area.ProgramadoDia4	--miercoles
				when 5 then Area.ProgramadoDia5	--jueves
				when 6 then					--viernes
						isnull(case Area.ProgramadoDia6
							 		when 0 then
										(
											select	A.ProgramadoDia1 --lunes
											from	Sistema.dbo.CP_Revisiones_Produccion_Asignacion A with (READUNCOMMITTED)
													inner join Sistema.dbo.CP_Contenedores C with (READUNCOMMITTED)on C.ContenedorID = A.ContenedorID
											where	C.ContenedorID = Contenedor.ContenedorID+1
													and A.Part = TopPart
										)
									else Area.ProgramadoDia6 --sabado
								end,0)
				when 7 then					--sabado
						isnull((
								select	A.ProgramadoDia1 --lunes
								from	Sistema.dbo.CP_Revisiones_Produccion_Asignacion A with (READUNCOMMITTED)
										inner join Sistema.dbo.CP_Contenedores C with (READUNCOMMITTED) on C.ContenedorID = A.ContenedorID
								where	C.ContenedorID = Contenedor.ContenedorID+1
										and A.Part = TopPart
								),0)
			end	as [Requerido Diario],
			isnull(L.quantity,0)[Cargado Diario],
			isnull(case LS.dia
				when 6 then (case isnull(Area2.ProgramadoDia6,0)
								when 0 then LS.quantitys2
								else LS.quantitys1
							end)
				when 7 then LS.quantitys2
				when 1 then LS.quantitys1
				when 2 then LS.quantitys1
				when 3 then LS.quantitys1
				when 4 then LS.quantitys1
				when 5 then LS.quantitys1
			end,0) [Cargado Acumulado],			
			LS.dia
	from	FT.Xrt Xrt with (READUNCOMMITTED)
			join Part Part with (READUNCOMMITTED) on Xrt.ChildPart = Part.Part 
			inner join Sistema.dbo.CP_Revisiones_Produccion_Asignacion Area with (READUNCOMMITTED) on Area.Part = 	Xrt.TopPart
			inner join Sistema.dbo.CP_Contenedores Contenedor with (READUNCOMMITTED) on Contenedor.ContenedorID = Area.ContenedorID
			left join Sistema.dbo.CP_Revisiones_Produccion_Asignacion Area2 with (READUNCOMMITTED) on Area2.Part = Xrt.TopPart and Area2.ContenedorID = Area.ContenedorID-1
			left join PartConvertion Convertion with (READUNCOMMITTED) on Convertion.Part = Xrt.ChildPart
			left join (--cargado del dia
				select	at.part,to_loc,sum(isnull(at.quantity,0))quantity
				from	audit_trail at with (READUNCOMMITTED)
						inner join location lo with (READUNCOMMITTED) on at.to_loc = lo.code
				where	datepart(y,date_stamp)=datepart(y,getdate())
						and year(date_stamp)=year(getdate())
						and lo.group_no like 'ENSAMBLE'
						and at.type = 'T'
				group by at.part,to_loc
			) as L on ltrim(rtrim(L.part)) = ltrim(rtrim(ChildPart)) and ltrim(rtrim(L.to_loc)) = ltrim(rtrim(left(TopPart,len(TopPart)-5)))
			left join (--cargado de la semana
						select	case when at1.part is null then at2.part else at1.part end as part,
								case when at1.to_loc is null then at2.to_loc else at1.to_loc end as to_loc,
								case when at1.dia is null then at2.dia else at1.dia end dia,
								isnull(at1.quantity,0)quantitys1 ,isnull(at2.quantity,0)quantitys2
						from
							(
								select Part,to_loc,sum(quantity)quantity,dia
								from(
									select	at.part,to_loc,sum(isnull(at.quantity,0))quantity,datepart(dw,date_stamp)dia
									from	audit_trail at with (READUNCOMMITTED)
											inner join location lo with (READUNCOMMITTED) on at.to_loc = lo.code
									where	datepart(wk,date_stamp)=datepart(wk,getdate())
											and year(date_stamp)=year(getdate())
											and lo.group_no like 'ENSAMBLE'
											and at.type = 'T'
									group by at.part,to_loc,datepart(dw,date_stamp)
									union
									select	at.part,from_loc to_loc,-sum(isnull(at.quantity,0))quantity,datepart(dw,date_stamp)dia
									from	audit_trail at with (READUNCOMMITTED)
											inner join location lo with (READUNCOMMITTED) on at.from_loc = lo.code
									where	to_loc = 'POTING-P3'
											and lo.group_no like 'ENSAMBLE'
											and datepart(y,date_stamp)=datepart(y,getdate())
											and year(date_stamp)=year(getdate())
									group by at.part,from_loc,datepart(dw,date_stamp)
								) N
								group by part,to_loc,dia
							) at1
							full outer join(	
								select Part,to_loc,sum(quantity)quantity,dia
								from(
										select	at.part,to_loc,sum(isnull(at.quantity,0))quantity,datepart(dw,date_stamp)dia
										from	audit_trail at with (READUNCOMMITTED)
												inner join location lo with (READUNCOMMITTED) on at.to_loc = lo.code
										where	datepart(wk,date_stamp)=datepart(wk,getdate())-1
												and year(date_stamp)=year(getdate())
												and lo.group_no like 'ENSAMBLE'
												and at.type = 'T'
										group by at.part,to_loc,datepart(dw,date_stamp)
										union
										select	at.part,from_loc to_loc,-sum(isnull(at.quantity,0))quantity,datepart(dw,date_stamp)dia
										from	audit_trail at with (READUNCOMMITTED)
												inner join location lo with (READUNCOMMITTED) on at.from_loc = lo.code
										where	to_loc = 'POTING-P3'
												and lo.group_no like 'ENSAMBLE'
												and datepart(wk,date_stamp)=datepart(wk,getdate())-1
												and year(date_stamp)=year(getdate())
										group by at.part,from_loc,datepart(dw,date_stamp)
								) as N
								group by part,to_loc,dia								
							) at2 on at1.part = at2.part and at1.to_loc = at2.to_loc and at1.dia = at2.dia
			) as LS on ltrim(rtrim(LS.Part)) = ltrim(rtrim(ChildPart)) and ltrim(rtrim(LS.to_loc)) = ltrim(rtrim(left(TopPart,len(TopPart)-5)))

	where	BomLevel = isnull((select 2
								from FT.Xrt	Xrt1
								where Xrt1.ChildPart like 'POST-%' and Xrt1.TopPart = Xrt.TopPart), 1 )
			and TopPart in ( select TopPart 
								from FT.Xrt	
									join Part on Part.Part = FT.Xrt.Toppart
								where ChildPart like 'POT%' and Type = 'f')
			and ChildPart not like 'POT-%'
			and ChildPart not like 'MOLD-%'
			and Commodity <> 'IDLabel'
			and Contenedor.Activo = 1
	) as T
group by T.TopPart,
		T.Line,
		T.ChildPart,
		T.Xqty,
		T.Factor,
		T.[Requerido Total],
		T.[Requerido Acumulado],
		T.[Requerido Diario],		
		T.[Cargado Diario],
		T.[Dia a Cargar]
GO
