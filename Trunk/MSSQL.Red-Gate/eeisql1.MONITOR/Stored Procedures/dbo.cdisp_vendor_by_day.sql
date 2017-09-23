SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[cdisp_vendor_by_day](@day_list varchar(7)) as
begin
  /*----------------------------------------------------------------------------------*/
  /* cdisp_vendor_by_day*/
  /* Gather list of vendors to be sent on days indicated by parameter string*/
  /* 12/2002 by Bruce Harold*/
  /*----------------------------------------------------------------------------------*/
  /* Define variables*/
  declare @i integer,
  @day_char_check char(3)
  create table #vendor_select(
    vendor varchar(10) not null,
    )
  select @i=1
  while @i<=len(@day_list)
    begin
      select @day_char_check='%'+substring(@day_list,@i,1)+'%'
      insert into #vendor_select
        select edi_vendor.vendor
          from edi_vendor
          where auto_create_po='Y'
          and send_days like @day_char_check
      select @i=@i+1
    end
  /* Return results*/
  select distinct vendor
    from #vendor_select order by
    vendor asc
end

GO
