SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- exec eeiuser.acctg_update_transfer_pricing @fiscal_year = '2011', @period = '07'


-----------------------------------------------------------------------------------------------------------
-- This procedure identifies and corrects intercompany transfer prices that are different in EEH or EEI 
--
--	A. Populate table variable with Corrected Transfer Prices
--	B. Update EEH Database with Corrected Transfer Prices
--		1. Update part setups 
--			i.	 part_customer
--			ii.  part_standard 
--			iii. part_standard_historical 
--			iv.	 part_standard_historical_daily
--		2. Update open orders 
--			i.	 order_header
--			ii.  order_detail
--		3. Update shipouts 
--			i.	 shipper
--			ii.  shipper_detail
--
--	C. Update EEI Database with Corrected Customer Selling Prices and Corrected Transfer Prices
--		1. Update part setups
--			i.	part_standard
--			ii. part_standard_historical
--			iii. part_standard_historical_daily
--		2. Update receipts
--			i.	audit_trail
--
---------------------------------------------------------------------------------------------------


CREATE procedure [eeiuser].[acctg_update_transfer_pricing] (@fiscal_year varchar(4), @period varchar(2))

as
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET transaction isolation level read uncommitted

/************************************************************************************************************
	A. Populate the table variable with Corrected Transfer Prices														
	
************************************************************************************************************/

declare		@TransferPriceCorrections table
		(		Part varchar(25) primary key
			,	Customer_Production_Selling_Price decimal(18,6)
			,	Transfer_Price decimal(18,6)
		)

insert		@TransferPriceCorrections
select		Part = tpc.part
		,	Customer_Production_Selling_Price = tpc.customer_production_selling_price
		,	Transfer_Price = tpc.transfer_price
from		eeiuser.acctg_transfer_price_corrections tpc
where		tpc.fiscal_year = @fiscal_year
		and	tpc.period = @period


/************************************************************************************************************
	B. Update EEH database																
		1. Update part setups															
			i. Update [part_customer] with corrected transfer price						
************************************************************************************************************/

update		pc 
set			blanket_price = tpc.transfer_price
from		part_customer pc
	join	@TransferPriceCorrections tpc 
	on		tpc.part = pc.part 


/************************************************************************************************************
	B. Update EEH database																
		1. Update part setups															
			ii. Update [part_standard] with corrected transfer price					
************************************************************************************************************/

update		ps
set			price = tpc.transfer_price
from		part_standard ps
	join	@TransferPriceCorrections tpc  
		on	tpc.part = ps.part


/************************************************************************************************************
	B. Update EEH database																
		1. Update part setups															
			iii. Update [part_standard_historical] with corrected transfer price		
************************************************************************************************************/

update		psh
set			price = tpc.transfer_price
from		part_standard_historical psh
	join	@TransferPriceCorrections tpc  
	on		tpc.part = psh.part 
where		psh.fiscal_year >= @fiscal_year
		and psh.period >= @period
		and psh.time_stamp >= @fiscal_year + '-' + @period + '-01'


/************************************************************************************************************
	B. Update EEH database																
		1. Update part setups															
			iv. Update [part_standard_historical_daily] with corrected transfer price	
************************************************************************************************************/

update		part_standard_historical_daily
set			price = tpc.transfer_price
from		part_standard_historical_daily pshd
	join	@TransferPriceCorrections tpc 
		on	tpc.part = pshd.part 
where		pshd.fiscal_year >= @fiscal_year
		and pshd.period >= @period
		and pshd.time_stamp >= @fiscal_year + '-' + @period + '-01'


/************************************************************************************************************
	B. Update EEH database																
		2. Update orders																
			i. Update [order_header] with the corrected transfer price					
************************************************************************************************************/

update		oh
set			price = tpc.transfer_price
		   ,alternate_price = tpc.transfer_price
from		order_header oh
	join	@TransferPriceCorrections tpc 
	on		tpc.part = oh.blanket_part


/************************************************************************************************************
	B. Update EEH database																
		2. Update orders																
			ii. Update [order_detail] with the corrected transfer price					
************************************************************************************************************/

update		od
set			price = tpc.transfer_price
		   ,alternate_price = tpc.transfer_price
from		order_detail od
	join	@TransferPriceCorrections tpc 
	on		tpc.part = od.part_number


/************************************************************************************************************
	B. Update EEH database																
		3. Update shipouts																
			i. Update [shipper_detail] with corrected transfer price				 	
************************************************************************************************************/

update		sd
set			price = tpc.transfer_price
		   ,alternate_price = tpc.transfer_price
from		shipper_detail sd
	join	shipper s  
		on	sd.shipper = s.id
	join	@TransferPriceCorrections tpc 
		on	tpc.part = sd.part_original
where		s.date_shipped >= @fiscal_year + '-' + @period + '-01'
									  

/************************************************************************************************************
	B. Update EEH database																
		3. Update shipouts																
			ii. Update [shipper] so they can be reimported into Empower					
************************************************************************************************************/

update		s
set			posted = 'N'
from		shipper s
	join	shipper_detail sd 
		on	s.id = sd.shipper
	join	@TransferPriceCorrections tpc 
		on	tpc.part = sd.part_original
where		s.date_shipped >= @fiscal_year + '-' + @period + '-01'


GO
