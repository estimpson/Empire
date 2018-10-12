SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec HN.MAT_Wip_Requiriment

*/
CREATE procedure [HN].[MAT_Wip_Requiriment] as

create	table #WhereUse
	(	Part varchar(25),
		whereUse varchar(1200) )
		
declare	@ContainerDT datetime
			
insert into #WhereUse
exec eeh.HN.HCSP_Mat_WhereUseList NULL,'BOM',NULL,'Y'

select t1.serial,t1.part,t1.location,t1.std_quantity,t1.status,t1.user_defined_status,t1.group_no,t1.Machine,t1.cost_cum,t1.ExtendCost,t1.tipo,group_machine=l.group_no,
Date_shipout=(select eeh.hn.fn_GetOriginalDT(t1.serial)),
t1.secured_location,last_date ,whereUse.whereUse 
from (           select      serial, Object.part, location, std_quantity, object.status, 
                        user_defined_status, group_no, Machine, cost_cum, 
                        ExtendCost =  std_quantity * cost_cum, Tipo = 'Sin Req.',secured_location,last_date
            from  object with (readuncommitted, nolock)
                        join setups_location with (readuncommitted, nolock) on Object.location = setups_location.code
                        join part_machine with (readuncommitted, nolock) on part_machine.part = object.part
                        join part_standard on part_standard.part = Object.part
                        join part on part.part = Object.part
            where part.type = 'W'
                        and object.quantity > 0
                        and object.location not in ('RMASCRAP')
                        and group_no not in ('LOST','TROY','lost/scrap','NEW JOBS' ) and object.part not like 'EEM0180%' and object.part not like 'EEM0181%'
                        and Object.part not in(
                                    select      Distinct Object.Part
                                    from  (     select      part 
                                                      from  CP_Contenedores_Futuros with (readuncommitted, nolock)
                                                                  join CP_Contenedores on CP_Contenedores_Futuros.ContenedorID = CP_Contenedores.ContenedorID
                                                      where Activo = 1
                                                      union all
                                                      select      part
                                                      from  cp_revisiones_produccion with (readuncommitted, nolock)
                                                                  join CP_Contenedores on cp_revisiones_produccion.ContenedorID = CP_Contenedores.ContenedorID
                                                      where Activo = 1 ) Futuros
                                                join FT.xrt xrt on xrt.TopPart = Futuros.Part
                                                join Part on part.part = xrt.ChildPart
                                                join Object with (readuncommitted) on xrt.ChildPart = object.part
                                    where part.type = 'W' )

            union all
            select      serial, Object.part, location, std_quantity, object.status, 
                        user_defined_status, group_no, Machine, cost_cum, 
                        ExtendCost =  std_quantity * cost_cum, Tipo = 'Con Req.',secured_location,last_date
            from  object with (readuncommitted, nolock)
                        join setups_location with (readuncommitted, nolock) on Object.location = setups_location.code
                        join part_machine with (readuncommitted, nolock) on part_machine.part = object.part
                        join part_standard on part_standard.part = Object.part
                        join part on part.part = Object.part
            where part.type = 'W'
                        and Object.status = 'H'
                        and object.quantity > 0
                        and group_no not in ('LOST', 'lost/scrap','TROY' ) and object.part not like 'EEM0180%' and object.part not like 'EEM0181%'
                        and Object.part in(
                                    select      Distinct Object.Part
                                    from  (     select      part 
                                                      from  CP_Contenedores_Futuros with (readuncommitted, nolock)
                                                                  join CP_Contenedores on CP_Contenedores_Futuros.ContenedorID = CP_Contenedores.ContenedorID
                                                      where Activo = 1
                                                      union all
                                                      select      part
                                                      from  cp_revisiones_produccion
                                                                  join CP_Contenedores on cp_revisiones_produccion.ContenedorID = CP_Contenedores.ContenedorID
                                                      where Activo = 1 ) Futuros
                                                join FT.xrt xrt with (readuncommitted, nolock) on xrt.TopPart = Futuros.Part
                                                join Part on part.part = xrt.ChildPart
                                                join Object with (readuncommitted, nolock) on xrt.ChildPart = object.part
                                    where part.type = 'W' ) ) as t1 
					inner join setups_location l on t1.Machine=l.code
					LEFT JOIN #WhereUse WhereUse on whereUse.Part = t1.part 
Union
select  o.serial,o.part,o.location,o.std_quantity,o.status,o.user_defined_status,ll.group_no,'RAW',ps1.cost_cum,o.quantity*ps1.cost_cum,'RAW','RAW','1990/1/1',
ll.secured_location,last_date , whereUse.whereUse 
from object o with (readuncommitted, nolock) 
inner join part p on o.part = p.part 
inner join setups_location ll on ll.code=o.location 
inner join part_standard ps1 on o.part=ps1.part 
LEFT JOIN #WhereUse WhereUse on whereUse.Part = p.part 
where p.type='r' and ll.group_no='ret-bodega'
GO
