SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_ATManualAdds_fxDelete](@begindate timestamp,@enddate timestamp) as
begin
  create table #ManualAdds(
    Serial integer null,
    Part varchar(25) null,
    location varchar(20) null,
    note varchar(255) null,
    Qty decimal(20,6) null,
    Operator varchar(10) null,
    PartDesc varchar(50) null,
    time_stamp timestamp null,
    defect varchar(10) null,
    )
  create index idx_#ManualAdds_1 on #ManualAdds(Serial asc)
  begin
    begin transaction
    insert into #ManualAdds(Serial,
      Part,
      location,
      note,
      Qty,
      Operator,
      PartDesc,
      time_stamp,
      defect)
      select serial,
        audit_trail.part,
        audit_trail.to_loc,
        audit_trail.notes,
        audit_trail.quantity,
        audit_trail.operator,
        part.name,
        audit_trail.date_stamp,
        audit_trail.custom5
        from audit_trail join
        part on audit_trail.part=part.part
        where audit_trail.type='A'
        and audit_trail.date_stamp>=@begindate
        and audit_trail.date_stamp<dateadd(dd,1,@enddate)
    commit transaction
  end
  select Serial,
    Part,
    location,
    note,
    Qty,
    Operator,
    employee.name,
    PartDesc,
    time_stamp,
    defect
    from #ManualAdds join
    employee on #ManualAdds.operator=employee.operator_code
    where len(rtrim(defect))>=1 order by
    2 asc,1 asc
end

GO
