SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[HCSP_CP_Revisiones_Produccion]
	( @Contenedor datetime )
	
as
/*

	exec HN.HCSP_CP_Revisiones_Produccion
			@ContenedorID = 131

*/

declare	@Revision table
	([Orden] int not null,
	[Part] [varchar](25) NOT NULL ,
	[standard_pack] [numeric](20, 6) NULL,
	[Revision4] [int] NULL,
	[Revision3] [int] NULL,
	[Revision2] [int] NULL,
	[Revision1] [int] NULL,
	[Comentario1] [nvarchar](200) NULL,
	[EstatusProduccion] [nvarchar](10) NULL,
	[MaterialCritico] [nvarchar](50) NULL,
	[AreaMaterialCritico] [nvarchar](50) NULL,
	[cross_ref] [varchar](50) NULL,
	[Price] [numeric](20, 6) NULL,
	[HojaCorte] [varchar](5) NOT NULL,
	[PONumber] [numeric](8, 0) NULL,
	[CoordinadorProduccion] [nvarchar](30) NULL,
	[IngProduccion] [nvarchar](30) NULL,
	[TipoCaja] [varchar](20) NULL )


insert into @Revision
select	Orden = 1, Revision.Part, part_inventory.standard_pack, Revision4, Revision3, Revision2 , Revision1,
		Comentario1, EstatusProduccion, MaterialCritico, AreaMaterialCritico,
		Part.cross_ref, Prices.Price, HojaCorte = case when HC_Partes.part is null then 'NO OK' else 'OK' end,
		orders.PONumber, sa_partes.CoordinadorProduccion, sa_partes.IngProduccion, packaging.TipoCaja
from	CP_Revisiones_Produccion Revision
		join CP_Contenedores on Revision.ContenedorID = CP_Contenedores.ContenedorID
		join Part on part.part = Revision.part
		join part_inventory on Revision.Part = part_inventory.part
		join sa_partes on sa_partes.part = Revision.part
		left join ( select	Part = blanket_part, PONumber = MAX( order_no ) 
					from	order_header_eei
					group by blanket_part ) orders on orders.Part = Revision.part
		left join (	select	part, TipoCaja = MAX(Code)
					from	part_packaging
					group by part ) packaging on packaging.part = Revision.part
		left join sistema.dbo.HC_Partes HC_Partes on HC_Partes.Part = Revision.part and HC_Partes.Materiales = 1
		left join (	select	distinct Part = part_number, Price = isnull(order_detail.price, order_header.price)		
					from	[EEISQL1].Monitor.dbo.order_detail order_detail
							join [EEISQL1].MONITOR.dbo.order_header order_header on order_header.order_no = order_detail.order_no	) Prices on Revision.part = Prices.Part
where	Datediff(d, FechaEEH , @Contenedor) = 0
order by Revision.Part


insert into @Revision (Orden, Part, HojaCorte)
values(	2, '', '')

insert into @Revision (Orden, Part, HojaCorte)
values(	2, '', '')

insert into @Revision (Orden, Part, HojaCorte)
values(	3, 'Tipos de Caja', '')

insert into @Revision (Orden, Part, Revision3, Revision2, Revision1, HojaCorte)
select	Orden = 4, 
		isnull(Revision.TipoCaja, 'CajaNoDefinida'), 
		CajasRev3 = sum( ceiling( Revision3 / standard_pack )),
		CajasRev2 = sum( ceiling( Revision2 / standard_pack)),
		CajasRev1 = sum( ceiling( Revision1 / standard_pack)),
		HojaCorte = ''
from	@Revision Revision
group by Revision.TipoCaja

insert into @Revision (Orden, Part, Revision3, Revision2, Revision1, HojaCorte)
select	Orden = 5, 
		'Posiciones', 
		PosRev3 = sum( ceiling( Revision3 / CantidadPorPosiciones )),
		PosRev2 = sum( ceiling( Revision2 / CantidadPorPosiciones)),
		PosRev1 = sum( ceiling( Revision1 / CantidadPorPosiciones)),
		HojaCorte = ''
from	@Revision Revision
		join sa_tipo_cajas on Revision.Part = sa_tipo_cajas.code
where	Orden = 4
group by Revision.TipoCaja

insert into @Revision (Orden, Part, Revision3, Revision2, Revision1, HojaCorte)
select	Orden = 6, 
		'Ventas', 
		CajasRev3 = sum(  Revision3 * price ),
		CajasRev2 = sum(  Revision2 * price ),
		CajasRev1 = sum(  Revision1 * price ),
		HojaCorte = ''
from	@Revision Revision



select	*
from	@Revision 
order by Orden, Part


GO
