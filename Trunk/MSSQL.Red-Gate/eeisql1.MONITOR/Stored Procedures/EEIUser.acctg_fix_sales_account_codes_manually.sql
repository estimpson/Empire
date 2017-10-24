SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[acctg_fix_sales_account_codes_manually] @shipper int
as


-- This procedure is necessary to correct part.gl_account_code and part_eecustom.sales_return_account
-- It would be better to define this at the product_line level and then inherit from product_line into part and part_eecustom


update pe set sales_return_account = '4031' from part_eecustom pe join part p on pe.part = p.part where p.type = 'F' and p.product_line = 'WIRE HARN-EEH' 

update pe set sales_return_account = '4041' from part_eecustom pe join part p on pe.part = p.part where p.type = 'F' and p.product_line = 'BULBED WIRE HARN-EEH'

update pe set sales_return_account = '4051' from part_eecustom pe join part p on pe.part = p.part where p.type = 'F' and p.product_line = 'ES3 COMPONENTS'

update pe set sales_return_account = '4061' from part_eecustom pe join part p on pe.part = p.part where p.type = 'F' and p.product_line = 'BULBED ES3 COMPONENTS'

update pe set sales_return_account = '4081' from part_eecustom pe join part p on pe.part = p.part where p.type = 'F' and p.product_line = 'PCB'


update p set gl_account_code = '4030' from part p where p.type = 'F' and p.product_line = 'WIRE HARN-EEH' 

update p set gl_account_code = '4040' from part p where p.type = 'F' and p.product_line = 'BULBED WIRE HARN-EEH'

update p set gl_account_code = '4050' from part p where p.type = 'F' and p.product_line = 'ES3 COMPONENTS'

update p set gl_account_code = '4060' from part p where p.type = 'F' and p.product_line = 'BULBED ES3 COMPONENTS'

update p set gl_account_code = '4080' from part p where p.type = 'F' and p.product_line = 'PCB'



update sd set account_code = '4031' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'WIRE HARN - EEH' and isnull(s.type,'XYZ') = 'R' and s.id = @shipper

update sd set account_code = '4041' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'BULBED WIRE HARN-EEH' and isnull(s.type,'XYZ') = 'R' and s.id = @shipper

update sd set account_code = '4051' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'ES3 COMPONENTS' and isnull(s.type,'XYZ') = 'R' and s.id = @shipper

update sd set account_code = '4061' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'BULBED ES3 COMPONENTS' and isnull(s.type,'XYZ') = 'R' and s.id = @shipper

update sd set account_code = '4081' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'PCB' and isnull(s.type,'XYZ') = 'R' and s.id = @shipper



update sd set account_code = '4030' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'WIRE HARN - EEH' and isnull(s.type,'XYZ') <> 'R' and sd.shipper = @shipper

update sd set account_code = '4040' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'BULBED WIRE HARN-EEH' and isnull(s.type,'XYZ') <> 'R' and sd.shipper = @shipper

update sd set account_code = '4050' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'ES3 COMPONENTS' and isnull(s.type,'XYZ') <> 'R' and sd.shipper = @shipper

update sd set account_code = '4060' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'BULBED ES3 COMPONENTS' and isnull(s.type,'XYZ') <> 'R' and sd.shipper = @shipper

update sd set account_code = '4080' from shipper_detail sd join part p on sd.part_original = p.part join shipper s on sd.shipper = s.id where p.type = 'F' and p.product_line = 'PCB' and isnull(s.type,'XYZ') <> 'R' and sd.shipper = @shipper



update shipper set posted = 'N' where id = @shipper

GO
