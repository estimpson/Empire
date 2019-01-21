SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[eeisp_ars_nonorderstatus_fxDelete]
as 

begin

select * from vw_ars_exception_nonorderstatus

end
GO
