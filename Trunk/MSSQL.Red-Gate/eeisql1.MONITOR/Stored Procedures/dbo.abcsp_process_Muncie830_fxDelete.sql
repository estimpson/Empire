SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create procedure [dbo].[abcsp_process_Muncie830_fxDelete]

as
Begin
DELETE Log

BEGIN TRANSACTION
Delete m_in_release_plan
COMMIT TRANSACTION

Create table #releasePlan (
							lineid	integer identity,
							customerpart	varchar (35),
							destination		varchar (20),
							customerPO		varchar	(20),
							modelYear		varchar	(4),
							ReleaseNumber	varchar(30),
							QtyQual		char(1),
							Qty			numeric(20,6),
							DateType		char(1),
							ReleaseDate		datetime,
							CustomerAccum	numeric (20,6))

insert 	#releasePlan( 			customerpart,
							destination,
							customerPO,
							modelYear,
							ReleaseNumber,
							QtyQual,
							Qty,
							DateType,
							ReleaseDate,
							customerAccum)
	select 		rtrim(edi_muncie830_detail.Customer_part) as custpart,
				edi_setups.destination,
				rtrim(edi_muncie830_detail.customer_po),
				'',
				rtrim(edi_muncie830_detail.referenceID)+'*'+rtrim(FSTRelease),
				'A',
				convert(numeric(20,6),edi_muncie830_detail.Qty),
				'S',
				dateadd(day, (-1*isNULL (edi_setups.id_code_type,0)),convert(datetime,schedStartDate)) reldate,
				isNULL(convert(numeric(20,6),edi_muncie830_header.SHPQty),0)
	 FROM 		edi_muncie830_detail
	 LEFT OUTER JOIN 	edi_setups  ON rtrim(edi_muncie830_detail.ship_to) = edi_setups.parent_destination
	 LEFT OUTER JOIN	edi_muncie830_header  ON rtrim(edi_muncie830_detail.ship_to) = rtrim(edi_muncie830_header.ship_to) and rtrim(edi_muncie830_detail.customer_part) = rtrim(edi_muncie830_header.customer_part) and rtrim(edi_muncie830_detail.referenceid) = rtrim(edi_muncie830_header.referenceid)
		WHERE		rtrim(edi_muncie830_header.DateType) = '051' and
				rtrim(edi_muncie830_header.ShpQtyType) = '02'
	  
	 	 order by edi_setups.destination,custpart,reldate         
		

insert m_in_release_plan (	customer_part,
					shipto_id,
					customer_po,
					model_year,
					release_no,
					quantity_qualifier,
					quantity,
					release_dt_qualifier,
					release_dt)
	select 	customerpart,
			destination,
			customerPO,
			ModelYear,
			ReleaseNumber,
			QtyQual,
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid)+CustomerAccum,
			DateType,
			ReleaseDate
	 FROM #releasePlan
	 order by destination, customerpart, ReleaseDate       



execute msp_process_in_release_plan

Delete	edi_muncie830_detail

Delete	edi_muncie830_header
end


GO
