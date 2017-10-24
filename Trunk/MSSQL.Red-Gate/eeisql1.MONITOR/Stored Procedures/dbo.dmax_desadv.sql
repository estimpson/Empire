SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[dmax_desadv] (@shipper integer) as

begin
	drop table dmaxAT_shipout
	create table dmaxAT_shipout (
						Parent_serial Integer,
						Part varchar(25),
						Qty Integer,
						Serial Integer)
						
	drop table dmaxpallets					
	create table dmaxPallets(
					PalletNumber	Integer IDENTITY,
					PalletSerial	Integer,
					StdPack				decimal (20,6))
										
						Insert dmaxAT_shipout
						Select	audit_trail.parent_serial,
										audit_trail.part,
										audit_trail.quantity,
										audit_trail.serial
							from	audit_trail
							where	type = 'S' and
										shipper = convert(varchar(15),@shipper) and
										part <> 'PALLET' 
				
				Insert	dmaxPallets (PalletSerial,
													StdPack)
				Select			Distinct Parent_serial,
										qty
					from			dmaxAT_shipout
					
										
					
					
								
SELECT 
			'16',
			convert( varchar(10),PalletNumber),
			convert(varchar(7),convert(integer,dmaxPallets.StdPack)) as std_pack,
			convert(varchar(6),(Select count(1) from dmaxAT_shipout at2 where at2.parent_serial = dmaxAT_shipout.parent_serial and at2.part = dmaxAT_shipout.part and at2.qty = dmaxPallets.StdPack)) as pallet_count,
			convert(varchar (8),dmaxAT_shipout.parent_serial),
			shipper_detail.customer_part,
			shipper_detail.part_original, 
			shipper_detail.customer_po,
			Convert(varchar (8),Convert(integer,shipper_detail.qty_packed)),     
			Convert(varchar(8), Convert(integer,order_header.our_cum)),
			order_header.line_feed_code as po_line,      
			edi_setups.supplier_code+ (CASE WHEN serial > 999999 THEN '0' ELSE '00' END)+convert(varchar(15), dmaxAT_shipout.serial) as Li_plate,
			edi_setups.supplier_code + (CASE WHEN parent_serial > 999999 THEN '0' ELSE '00' END)+ convert(varchar(15), dmaxAT_shipout.parent_serial) as p_Li_plate,
			Convert(varchar(8), Convert(integer,dmaxAT_shipout.Qty))
			  
    FROM 	order_header,   
         	shipper,   
         	shipper_detail,
					dmaxAT_shipout,
					dmaxPallets,
					edi_setups  
   WHERE ( edi_setups. destination = shipper.destination) and
					( dmaxAT_shipout.part = order_header.blanket_part) and
			( shipper_detail.part_original = order_header.blanket_part ) and
			( shipper_detail.order_no = order_header.order_no ) and  
         ( shipper_detail.shipper = shipper.id ) and
         ( dmaxPallets.Palletserial = dmaxAT_shipout.parent_serial) and
         ( dmaxPallets.stdPack = dmaxAT_shipout.qty)and
			( shipper.id = @shipper ) and
				dmaxAT_shipout.part <> 'PALLET'
			
			order by 2,3,4,5,11   
			
			end
GO
