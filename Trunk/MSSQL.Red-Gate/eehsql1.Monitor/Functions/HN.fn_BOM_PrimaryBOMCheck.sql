SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [HN].[fn_BOM_PrimaryBOMCheck]( 
		@Part varchar(25), 
		@Componet varchar(25))

returns	@Compartion table (
	[Parent_part] [varchar](25) NULL,
	[Part] [varchar](25) NULL,
	[HCQuantity] [decimal](20, 6) NULL,
	[BOMStdQty] [numeric](20, 6) NULL,
	[BOMQty] [numeric](20, 6) NULL,
	[ValidateQty] [varchar](5) NOT NULL,
	[HCUnitMeasure] [varchar](5) NULL,
	[BOMUnitMeasure] [varchar](2) NULL,
	[ValidateUnitMeasure] [varchar](5) NOT NULL) 
as
begin
/*

Exec HN.HCSP_BOM_PrimaryBOMCheck
	@Part = 'ALC0001-HF11',
	@Componet = 'CKT-ALC0001-2A'

*/

declare @BOM table
	(	Parent_part	varchar(25),
		Part	varchar(25),
		Quantity	decimal(20,6),
		UnitMeasure varchar(5))

--	Input of the first Terminal
insert into @BOM( Parent_Part, Part, Quantity, UnitMeasure )
select	Parent_part = @Componet, 
		Part = Terminal,
		Quantity = 1 ,
		UnitMeasure = 'EA'
from	sistema.dbo.HC_Circuito_Componentes Circuitos
		join Sistema.dbo.HC_q_Listado_Terminales Terminal1 on Circuitos.Terminal1 =Terminal1.TCFGID
where	part = @Part
		and Circuito = @Componet
		and isnull(esdesforre1,'N') = 'N'


--	Input of the first Grommet
insert into @BOM( Parent_Part, Part, Quantity, UnitMeasure )
select	Parent_part = @Componet, 
		Part = Terminal1.Grommet,
		Quantity = 1,
		UnitMeasure = 'EA'
from	sistema.dbo.HC_Circuito_Componentes Circuitos
		join Sistema.dbo.HC_q_Listado_Terminales Terminal1 on Circuitos.Terminal1 =Terminal1.TCFGID
where	part = @Part
		and Circuito = @Componet
		and isnull(esdesforre1,'N') = 'N'
		and coalesce(Terminal1.Grommet, 'N/A') <> 'N/A'


--	insert the wire
insert into @BOM( Parent_Part, Part, Quantity, UnitMeasure )
select	Parent_part = @Componet, 
		Part = Circuitos.Alambre,
		Quantity = round( Circuitos.Longitud / 304.8, 4),
		UnitMeasure = 'FT'
from	sistema.dbo.HC_Circuito_Componentes Circuitos
		join Sistema.dbo.HC_q_Listado_Terminales Terminal1 on Circuitos.Terminal1 =Terminal1.TCFGID
where	part = @Part
		and Circuito = @Componet
		and Circuitos.Alambre is not null



--	Input of the second Terminal
insert into @BOM( Parent_Part, Part, Quantity, UnitMeasure )
select	Parent_part = @Componet, 
		Part = Terminal,
		Quantity = 1,
		UnitMeasure = 'EA'
from	sistema.dbo.HC_Circuito_Componentes Circuitos
		join Sistema.dbo.HC_q_Listado_Terminales Terminal2 on Circuitos.Terminal2 =Terminal2.TCFGID
where	part = @Part
		and Circuito = @Componet
		and isnull(esdesforre2,'N') = 'N'


--	Input of the second Grommet
insert into @BOM( Parent_Part, Part, Quantity, UnitMeasure )
select	Parent_part = @Componet, 
		Part = Terminal2.Grommet,
		Quantity = 1,
		UnitMeasure = 'EA'
from	sistema.dbo.HC_Circuito_Componentes Circuitos
		join Sistema.dbo.HC_q_Listado_Terminales Terminal2 on Circuitos.Terminal2 =Terminal2.TCFGID
where	part = @Part
		and Circuito = @Componet
		and isnull(esdesforre2,'N') = 'N'
		and coalesce(Terminal2.Grommet, 'N/A') <> 'N/A'

insert into @Compartion
select	BOMHC.Parent_part,
		BOMHC.Part,
		HCQuantity = BOMHC.Quantity,
		BOMStdQty = bomec.std_Qty,
		BOMQty = bomec.Quantity,
		ValidateQty = case when (bomec.std_Qty - BOMHC.Quantity ) between -0.0002 and 0.0002
							then 'OK' else 'NO OK' end,
		HCUnitMeasure = BOMHC.UnitMeasure,
		BOMUnitMeasure = bomec.Unit_Measure,
		ValidateUnitMeasure = case when (BOMHC.UnitMeasure = bomec.unit_measure) 
								then 'OK' else 'NO OK' end
from	@BOM BOMHC
		left join bill_of_material_ec bomec on BOMHC.Part = bomec.Part and BOMHC.Parent_Part = bomec.Parent_Part
where	BOMHC.Parent_part = @Componet
		and bomec.end_datetime is null
		
return
end
GO
