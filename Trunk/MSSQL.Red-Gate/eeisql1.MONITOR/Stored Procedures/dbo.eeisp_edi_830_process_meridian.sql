SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_edi_830_process_meridian]

as
BEGIN

Truncate table Log

Truncate table m_in_release_plan

insert 		m_in_release_plan
	select 			EDIReleaseQty.CustomerPart,
					isNULL(MonitorDestination, 'Add ST ' + ShipTo ),
					isNULL(CustomerPO, ''),
					'',
					EDIReleaseQty.ReleasePlanID,
					'N',
					EDIQuantity,
					'S',		
					dateadd(dd, -1*isNULL(TransitDays,0),EDIDate)
	
	 FROM 	(	Select		rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID,
							rtrim(n1_04) as ShipTo,
							max(edi_setups.destination) as MonitorDestination,
							max(isNULL (edi_setups.id_code_type,0)) as TransitDays
				from			edi_830_Address
				left join		edi_setups on rtrim(edi_830_Address.n1_04) = edi_setups.parent_destination
				where		rtrim(n1_01) = 'ST'
				group by		rtrim(bfr_03)  + rtrim(bfr_08),
							rtrim(n1_04)
			) EDIShipTo FULL JOIN
			(	Select		rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID,
							rtrim(n1_04) as Supplier,
							max(edi_setups.Supplier_Code) as MonitorSupplier
				from			edi_830_Address
				left join		edi_setups on rtrim(edi_830_Address.n1_04) = edi_setups.parent_destination
				where		rtrim(n1_01) = 'SU'
				group by		rtrim(bfr_03)  + rtrim(bfr_08),
							rtrim(n1_04)
			) EDISupplier  on EDIShipTo.ReleasePlanID = EDISupplier.ReleasePlanID
			FULL JOIN
			(	Select		rtrim(bfr_03)  + rtrim(bfr_08) as ReleasePlanID,
							rtrim(lin_03) as CustomerPart,
							rtrim(lin_05) as CustomerPO,
							convert(datetime,fst_04) as EDIDate,
							convert(numeric (20,6), fst_01) as EDIQuantity
							
				from			edi_830_schedule
			) EDIReleaseQty on	EDIShipTo.ReleasePlanID =EDIReleaseQty.ReleasePlanID
		
            
execute msp_process_in_release_plan_meridian



Select ' Processed Meridian 830 EDI Release' +' ' + convert(varchar(25), getdate())
UNION
Select 'a: Updated Orders'
UNION
Select distinct 'a:'+substring("message",1,patindex('%release date%',"message" )-3) from log where "message" like '%inserted%'
UNION
Select 'b: Exceptions'
UNION
Select distinct 'b:'+"message" from log where "message" like 'Blanket Order%'
UNION
Select distinct 'b:'+"message" from log where "message" like 'Inbound release plan does not exist%'
order by 1

End
GO
