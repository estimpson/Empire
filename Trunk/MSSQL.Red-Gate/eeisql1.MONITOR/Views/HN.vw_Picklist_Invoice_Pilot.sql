SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [HN].[vw_Picklist_Invoice_Pilot]
as
Select distinct	
		VAFLOT,
		ItemNo = Summary.CrossRef,
		Summary.Part,		
		BoxesRequired=fifo.lotREq,
		Pieces= fifo.lotREq * Summary.standardpack
		,BoxWeight,
		BoxWeightTotal = BoxWeight * fifo.lotREq,
		UnitValue = UnitPrice,
		TotalAmmount = BoxPrice * (fifo.lotREq ),
		Summary.Shipperid
FROM	MONITOR.HN.Picklist_RF_DataExcel Summary
	inner join (Select	datos.crossref,
						datos.shipperid,
						Datos.Part,
						VAFLot= 'VAF'+ convert(varchar,Datos.LOT),
						Datos.lotREq
				FROM	MONITOR.HN.Picklist_RF_DataExcel Datos
					inner join (Select	crossref,
										LOT,
										shipperid
								FROM	MONITOR.HN.Picklist_RF_DataExcel	
								where	operator='PILOT'
									and tab='ShipperDetail'
									) Fifo
									on Datos.ShipperID= fifo.shipperid
										and Datos.crossref = fifo.crossref
										and datos.lot = fifo.LOT
				where	 operator='PILOT'
					and tab='PicklistDetail') Fifo
		on Summary.ShipperID= fifo.shipperid
			and Summary.crossref = fifo.crossref
	left join (Select pinv.part, 
						BoxWeight =  (isnull(standard_pack,1) * isnull(unit_weight,0) +  isnull(weight,0)), 
						UnitPrice =isnull(ps.price,0),
						BoxPrice = isnull(standard_pack,1) * isnull(ps.price,0)
				from   part_inventory pinv        
					   left join part_packaging ppackage
							 on ppackage.part = pinv.part
					   left join package_materials package
							 on ppackage.code = package.code
							 left join eehsql1.eeh.dbo.part_standard Ps
									on pinv.part = ps.part
					   join part 
							  on part.part = pinv.part
				where part.type='F') Peso
	 on peso.part = Summary.part
where	operator='PILOT'
	and tab='ShipperSummary'


GO
