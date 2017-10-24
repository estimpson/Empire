SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[vw_eei_edi_Meridian_Accums]
as
Select						*
							
		
from		(	Select			rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID,
							rtrim(n1_04) as ShipTo,
							max(edi_setups.destination) as MonitorDestination,
							max(isNULL (edi_setups.id_code_type,0)) as TransitDays
				from			edi_830_Address
				left join		edi_setups on rtrim(edi_830_Address.n1_04) = edi_setups.parent_destination
				where		rtrim(n1_01) = 'ST'
				group by		rtrim(bfr_03)  + rtrim(bfr_08),
							rtrim(n1_04)
			) EDIShipTo FULL JOIN
			(	Select		rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID2,
							rtrim(n1_04) as Supplier,
							max(edi_setups.Supplier_Code) as MonitorSupplier
				from			edi_830_Address
				left join		edi_setups on rtrim(edi_830_Address.n1_04) = edi_setups.parent_destination
				where		rtrim(n1_01) = 'SU'
				group by		rtrim(bfr_03)  + rtrim(bfr_08),
							rtrim(n1_04)
			) EDISupplier  on EDIShipTo.ReleasePlanID = EDISupplier.ReleasePlanID2
			FULL JOIN
			(	Select		rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID3,
							rtrim(lin_03) as CustomerPart,
							rtrim(lin_05) as CustomerPO,
							convert(datetime,shp_04) as EDIAccumStartDate,
							convert(numeric (20,6), shp_02) as EDIAccum
							
				from			edi_830_shp
				where		rtrim(shp_03) = '051'
				UNION
				Select		rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID3,
							rtrim(lin_03) as CustomerPart,
							rtrim(lin_05) as CustomerPO,
							convert(datetime,shp_04) as EDIAccumStartDate,
							convert(numeric (20,6), shp_02) as EDIAccum
							
				from			edi_830_shp
				where		shp_03  is NULL
			) EDIAccumYTDQty on	EDIShipTo.ReleasePlanID =EDIAccumYTDQty.ReleasePlanID3
			FULL JOIN
			(	Select		rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID4,
							rtrim(lin_03) as CustomerPart3,
							rtrim(lin_05) as CustomerPO3,
							convert(datetime,shp_04) as LastReceivedDate,
							convert(numeric (20,6), shp_02) as LastReceivedQty
							
				from			edi_830_shp
				where		rtrim(shp_03) = '050'
			) EDIAccumLastReceivedQty on	EDIShipTo.ReleasePlanID =EDIAccumLastReceivedQty.ReleasePlanID4 and EDIAccumYTDQty.CustomerPart = EDIAccumLastReceivedQty.CustomerPart3
			LEFT JOIN
			(	Select		order_no,
							destination,
							customer_part,
							blanket_part,
							isNULL(our_cum,0) As MonitorAccum
				from			order_header,
							part_eecustom
				where		order_header.blanket_part = part_eecustom.part and
							CurrentRevLevel  = 'Y' and
							blanket_part like 'MER%'
			) MonitorOrder on	 EDIShipTo.MonitorDestination = MonitorOrder.destination and 	EDIAccumLastReceivedQty.CustomerPart3 = MonitorOrder.customer_part	
GO
