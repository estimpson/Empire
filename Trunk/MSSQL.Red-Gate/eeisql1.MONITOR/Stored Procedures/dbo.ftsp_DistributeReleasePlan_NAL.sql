SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[ftsp_DistributeReleasePlan_NAL]
AS
Begin

TRUNCATE TABLE m_in_release_plan
insert m_in_release_plan
	select 	rtrim(lin03),
			COALESCE((SELECT		MAX(order_header.destination) 
				FROM	order_header
				JOIN	edi_setups ON order_header.destination = edi_setups.destination
				WHERE	order_header.customer_part = RTRIM(raw_830_release.lin03) AND
						edi_setups.parent_destination = RTRIM(raw_830_release.n104_1)), RTRIM(raw_830_release.n104_1) ),
			rtrim(lin05),
			'',
			COALESCE(rtrim(NULLIF(udf8,'')),rtrim(NULLIF(bfr_rel,''))),
			'N',
			convert(decimal(20,6),fst01),
			'S',
		
		dateadd(dd, -1*isNULL ((SELECT		MAX(edi_setups.id_code_type) 
				FROM	order_header
				JOIN	edi_setups ON order_header.destination = edi_setups.destination
				WHERE	order_header.customer_part = RTRIM(raw_830_release.lin03) AND
						edi_setups.parent_destination = RTRIM(raw_830_release.n104_1)),0),convert(datetime,fst04))
	 FROM "raw_830_release" 
	 
	 
	 	declare	@OrderRANS table(
			RANNumber	varchar(50) primary key,
			OrderNo	int,
			RanQty	numeric(20,6), 
			CustomerPart varchar(25),
			Destination		varchar(15)
			)  
   
       insert	@OrderRANS
                    ( RANNumber ,
                      OrderNo ,
                      RanQty,
                      CustomerPart ,
                      Destination
                    )
          select	
			RANNumber,
			max(OrderNo),
			sum(qty) ,
			sd.customer_part,
			s.destination
          from		
			dbo.NALRanNumbersShipped RANsShipped 
		join
			shipper_detail sd on RANsShipped.Shipper = sd.shipper and
			RANsShipped.OrderNo = sd.order_no
		join
			shipper s on sd.shipper = s.id
		where
			ShipDate>= dateadd(wk, -4, getdate()) 
			and	exists (select 1 from	dbo.m_in_release_plan mrp where mrp.customer_part =sd.customer_part and mrp.shipto_id = s.destination)
		group by
			RANNumber,
			sd.customer_part,
			s.destination
						   
    
   
     --Update Release Quantities by reducing by RAN Qty already shipped          
               update	m_in_release_plan
               set		quantity = quantity-isNULL(ORANs.RanQty,0)
               from		m_in_release_plan 
				left join
					@OrderRANS ORANs on  m_in_release_plan.customer_part = ORANs.CustomerPart and
						m_in_release_plan.shipto_id = ORANs.Destination and
						m_in_release_plan.release_no = ORANs.RanNumber
				delete
					dbo.m_in_release_plan
				where
					quantity<=0 
	 
	 
	 

--EXEC dbo.ftsp_DistributeReleasePlan

SELECT	'Inserted m_in_release_plan'

End


GO
