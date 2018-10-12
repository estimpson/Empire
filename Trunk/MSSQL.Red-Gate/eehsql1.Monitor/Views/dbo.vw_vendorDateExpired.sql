SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_vendorDateExpired]
as 
select	top 100 percent Code,Name,
			StatusActive=	case isnull(StatusActive,0)
								when 1 then 'ACTIVE'
								ELSE '' END,
			DateExpired,
			Status_Cert=CASE	
				when DATEDIFF(day,getdate(),dateexpired)<=0 then 'EXPIRED'
				when DATEDIFF(day,getdate(),dateexpired)>0 then 'PENDING'
			end
	from	eeh.dbo.vendor
	where	DATEDIFF(day,getdate(),dateexpired)<=90

	order by DateExpired
GO
