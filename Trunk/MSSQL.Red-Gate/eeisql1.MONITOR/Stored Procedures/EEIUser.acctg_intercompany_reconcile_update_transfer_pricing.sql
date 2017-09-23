SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
Object:			StoredProcedure [dbo].[acctg_intercompany_reconcile_update_transfer_pricing]   
Script Date:	08/04/2010 15:41:50
Authors:		Dan West
		
Use:			This procedure corrects intercompany transfer prices that are different in EEH or EEI
				Used by .net app "Intercompany Inventory Reconciliation" which is run during month end inventory reconciliation

Dependencies:	StoredProcedure [EEHSQL1].EEH.eeiuser.acctg_update_transfer_pricing 
				View *NONE*
				Table [EEISQL1].MONITOR.eeiuser.acctg_transfer_price_corrections
				Table [EEHSQL1].EEH.dbo.part_customer
				Table [EEHSQL1].EEH.dbo.part_standard
				Table [EEHSQL1].HISTORICALDATA.dbo.part_standard_historical
				Table [EEHSQL1].HISTORICALDATA.dbo.part_standard_historical_daily
				Table [EEHSQL1].EEH.dbo.order_header
				Table [EEHSQL1].EEH.dbo.order_detail
				Table [EEHSQL1].EEH.dbo.shipper
				Table [EEHSQL1].EEH.dbo.shipper_detail
				Table [EEISQL1].MONITOR.dbo.part_standard
				Table [EEISQL1].HISTORICALDATA.dbo.part_standard_historical
				Table [EEISQL1].HISTORICALDATA.dbo.part_standard_historical_daily
				Table [EEISQL1].MONITOR.dbo.audit_trail
				Function *NONE*
				
Change Log:		2014-12-01 03:00 PM; Dan West
				Changed the _historical table references to point to the new HistoricalData db
				
				2012-07-05 10:00 AM; Dan West
				Changed the db [EEHSQL1] linked server [EEISQL1] properties to allow RPC and RPC Out so that the
				nested (EEH) stored procedure would run within this (EEI) stored procedure

				2015-12-02 09:00 AM; Dan West
				Changed the procedure to use the data from eeiuser.acctg_inv_reconciliation as its source

Structure:		A. Populate table variable with Corrected Transfer Prices

				B. ** THIS STEP IS DONE LOCALLY ON THE EEH DB **
				   Update EEH Database with Corrected Transfer Prices
					1. Update part setups 
						i.	 part_customer
						ii.  part_standard 
						iii. part_standard_historical 
						iv.	 part_standard_historical_daily
					2. Update open orders 
						i.	 order_header
						ii.  order_detail
					3. Update shipouts 
						i.	 shipper
						ii.  shipper_detail

				C. Update EEI Database with Corrected Customer Selling Prices and Corrected Transfer Prices
					1. Update part setups
						i.	part_standard
						ii. part_standard_historical
						iii. part_standard_historical_daily
					2. Update receipts
						i.	audit_trail

				D. Update status on eeiuser.acctg_transfer_price_corrections
					1. Update acctg_transfer_price_corrections update status to yes

*/

-- exec eeiuser.acctg_intercompany_reconcile_update_transfer_pricing @fiscal_year = '2017', @period = '06', @beg_date = '2017-06-01' @Result = 99999


CREATE procedure [EEIUser].[acctg_intercompany_reconcile_update_transfer_pricing] 
	(@fiscal_year varchar(4), @period varchar(2), @beg_date date, @Result int output)

as
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET transaction isolation level read uncommitted
set @Result = 9999

--------------------------------------------------------------------------------------
--1. Format dates for use later on in the procedure (need a varchar for the openquery)
--------------------------------------------------------------------------------------

-- DECLARE	@BEG_DATE DATE = '2017-06-01'

DECLARE @beg_datetime datetime = @beg_date



/************************************************************************************************************
	A. Populate the table variable with Corrected Transfer Prices														
	
************************************************************************************************************/

declare		@TransferPriceCorrections table
		(		Part varchar(25) primary key
			,	Customer_Production_Selling_Price decimal(18,6)
			,	Transfer_Price decimal(18,6)
		)

-- run sp exec eeiuser.acctg_inv_sp_reconciliation 2016, 12 first to populate the acctg_inv_reconciliation table, then update using that data

--insert		@TransferPriceCorrections
--select		Part = tpc.part
--		,	Customer_Production_Selling_Price = tpc.customer_production_selling_price
--		,	Transfer_Price = tpc.transfer_price
--from		eeiuser.acctg_transfer_price_corrections tpc
--where		tpc.fiscal_year = '2017'
--		and	tpc.period = 4
--		and tpc.updated = 'n'

insert		@TransferPriceCorrections
select		distinct(tpc.p_part)
		,	tpc.ps_price
		,	tpc.ps_material_cum
from		eeiuser.acctg_inv_reconciliation tpc 
where		tpc.date_updated is null
-- and tpc.ps_material_cum is null

/************************************************************************************************************
	B. Execute EEH stored procedure
************************************************************************************************************/

exec [EEHSQL1].EEH.eeiuser.acctg_update_transfer_pricing @fiscal_year, @period, @beg_date
							

/************************************************************************************************************
	C. Update EEI database																
		1. Update part setups															
			i. Update [part_standard] with corrected transfer price					
************************************************************************************************************/

update		eeips
set			price = tpc.customer_production_selling_price
			,material = tpc.transfer_price
			,material_cum = tpc.transfer_price
			,cost = tpc.transfer_price
			,cost_cum = tpc.transfer_price
from		part_standard eeips
	join	@TransferPriceCorrections tpc 
		on	tpc.part = eeips.part


/************************************************************************************************************
	C. Update EEI database															
		1. Update part setups														
			ii. Update [part_standard_historical] with corrected transfer price		
************************************************************************************************************/

update		eeipsh
set			price = tpc.customer_production_selling_price
			,material = tpc.transfer_price
			,material_cum = tpc.transfer_price
			,cost = tpc.transfer_price
			,cost_cum = tpc.transfer_price
from		HistoricalData.dbo.part_standard_historical eeipsh
	join	@TransferPriceCorrections tpc  
		on	tpc.part = eeipsh.part
where		eeipsh.fiscal_year >= @fiscal_year
		and eeipsh.period >= @period
		and eeipsh.time_stamp >=  @beg_datetime


/************************************************************************************************************
--	C. Update EEI database																--
--		1. Update part setups															--
--			iii. Update [part_standard_historical_daily] with corrected transfer price	--
************************************************************************************************************/

update		eeipshd
set			price = tpc.customer_production_selling_price
			,material = tpc.transfer_price
			,material_cum = tpc.transfer_price
			,cost = tpc.transfer_price
			,cost_cum = tpc.transfer_price
from		HistoricalData.dbo.part_standard_historical_daily eeipshd
	join	@TransferPriceCorrections tpc  
		on	tpc.part = eeipshd.part
where		eeipshd.fiscal_year >= @fiscal_year
		and eeipshd.period >= @period
		and eeipshd.time_stamp >=  @beg_datetime


/************************************************************************************************************
	C. Update EEI database																
		2. Update receipts																
			iii. Update [audit_trail] so the transactions can be reimported into Empower
************************************************************************************************************/

update		eeiat
set			posted = 'N'
from		audit_trail eeiat
	join	@TransferPriceCorrections tpc 
		on	tpc.part = eeiat.part
where		eeiat.date_stamp >=  @beg_datetime


/************************************************************************************************************
	D. Update EEI database																
		3. Update status on acctg_transfer_price_corrections																
			iii. Update [acctg_transfer_price_corrections] to mark rows as being processed
************************************************************************************************************/

update		eeiuser.acctg_inv_reconciliation
set			date_updated = getdate()
where		isnull(date_updated,'') = ''


set @result = 0


GO
