SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[fn_CSM_MonitorPart]()
returns @PartsOfCSM table
	(	BasePart varchar(15) primary key,
		Part varchar(25) )
		--,
		--ForeCast_2017 numeric(18,3),
		--ForeCast_2018 numeric(18,3) )
as
begin 

insert into @PartsOfCSM( BasePart  ) --,  ForeCast_2015, ForeCast_2016 )
select	base_part -- , sum(Total_2017_TOTALdemand), sum(Total_2016_TOTALdemand)
from	csm_NACSM
group by base_part

update	@PartsOfCSM
set		Part = substring(PartToLookInBOM.PartGet, 2, 25)
from	@PartsOfCSM csm join 
		(select	Part = LEFT(part.part,7), PartGet = Max(case	when part.part like '%-H%' Then 'Z' 
					when part.part like '%-DS%' Then 'Y'
					when part.part like '%-PT%' Then 'X'
					else 'W' end + part.part)
			from	part
					join part_standard on part.part=part_standard.part
			where	type = 'F'
					and cost_cum > 0
			group by LEFT(part.part,7) ) PartToLookInBOM on PartToLookInBOM.Part = csm.BasePart

declare	@Future table
	(	BasePart varchar(15) primary key,
		Part varchar(25) )

insert into @Future(BasePart, Part )
select	BasePart = left(CP_Contenedores_Futuros.Part,7), Part = Min(CP_Contenedores_Futuros.Part)
from	CP_Contenedores
		join CP_Contenedores_Futuros on CP_Contenedores.ContenedorID = CP_Contenedores_Futuros.ContenedorID
		join part_standard on part_standard.part = CP_Contenedores_Futuros.Part
where	Activo = 1
		and cost_cum > 0 
group by left(CP_Contenedores_Futuros.Part,7)

update	@PartsOfCSM
set		Part = Future.part
from	@PartsOfCSM csm 
		join @Future Future on Future.BasePart = csm.basePart

	return
end
GO
