SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
	exec Monitor.hn.PROC_GETDATA_OVERDATA 4,2017
*/

CREATE PROCEDURE [HN].[PROC_GETDATA_OVERDATA] 
	@Month  int,
	@Year	int 
AS
BEGIN
			select	 QtyLate.Vendor,
					 Qty,
					 VendorLate,		 
					 PorIncumplimiento=(VendorLate/Qty) * 100 ,
					 PorCumplimiento=(1 - (VendorLate/Qty) ) * 100 
			from 	(select  Vendor
							,Qty=sum(AccumLowest) 
					 from eeh.dbo.MAT_OverReceipt_Historical with (readuncommitted)
					 where   MONTH(DTGenerateHistorical)= @Month
						   AND Year(DTGenerateHistorical) = @Year
						   --AND Vendor = 'ARROW'
					 group by Vendor
					) QtyVendor inner join 
					(select Vendor, 
							VendorLate=sum(case when AccumAjust + AccumReceived > AccumLowest then 0 else (AccumAjust + AccumReceived) - AccumLowest end) * -1
					 from eeh.dbo.MAT_OverReceipt_Historical with (readuncommitted)
					 where --(AccumAjust + AccumReceived) <= AccumLowest and ((AccumAjust + AccumReceived) - AccumLowest)!=0  and Part is not null
						    MONTH(DTGenerateHistorical)= @Month
						   AND Year(DTGenerateHistorical) = @Year
						  -- AND Vendor = 'ARROW'
					 group by vendor
					) QtyLate on QtyVendor.Vendor=QtyLate.Vendor

END

GO
