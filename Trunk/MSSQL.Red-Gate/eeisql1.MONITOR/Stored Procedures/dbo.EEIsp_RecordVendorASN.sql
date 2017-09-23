SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[EEIsp_RecordVendorASN] 
as
Begin
	
	Begin Transaction
	Delete VendorASNsWaitingforReview 
	from		VendorASNsWaitingforReview,
				RAWvendorASN
	where 	VendorASNsWaitingforReview.ASNID = Rtrim(RAWVendorASN.ASNID) and
				VendorASNsWaitingforReview.ShipFrom = Rtrim(RAWVendorASN.ShipFrom)
	Commit Transaction
	Begin Transaction
	Insert		VendorASNsWaitingforReview
	Select		rtrim(ASNID),
					convert(timestamp, rtrim(ASNDate)),
					rtrim(ShipFrom),
					rtrim(BOL),
					rtrim(SID),
					rtrim(EEpart),
					rtrim(EEPO),
					convert (decimal (20,6),QTYShipped),
					convert(decimal (20,6),CUMQtyShipped),
					convert (decimal(20,6),PackQty),
					Serial
					
	from			RAWvendorASN
	Commit Transaction
End

if not exists (select 1 from dbo.syscolumns, dbo.sysobjects where dbo.sysobjects.id = dbo.syscolumns.id and dbo.sysobjects.name = 'part_eecustom' and dbo.syscolumns.name = 'CSMTakeRate')
	alter table part_eecustom add CSMTakeRate numeric(20,6)  DEFAULT 100
GO
