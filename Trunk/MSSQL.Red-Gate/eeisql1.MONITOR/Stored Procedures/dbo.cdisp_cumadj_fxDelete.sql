SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[cdisp_cumadj_fxDelete](@as_vendor varchar(10),@as_part varchar(25),@ad_quantity decimal(20,6),@adt_date datetime)
as
begin
  begin transaction
  declare @week smallint
  select @week=datepart(wk,@adt_date)
  insert into vdp_table(vendor,part,week,po_number,cum_oqty,cum_rqty,date_evaluated,status) values(
    @as_vendor,@as_part,@week,0,0,-@ad_quantity,getdate(),'A')
  commit transaction
end

GO
