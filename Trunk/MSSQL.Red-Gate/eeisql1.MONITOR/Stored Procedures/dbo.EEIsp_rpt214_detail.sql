SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[EEIsp_rpt214_detail](@twofourteen varchar(25))
as
begin
  create table #214s_in(
    serial integer null,
    part varchar(25) null,
    quantity numeric(20,6) null,
    datereceived datetime null,
    )
  create table #214s_out(
    serial integer null,
    part varchar(25) null,
    quantity numeric(20,6) null,
    dateout datetime null,
    ITNo varchar(50) null,
    )
  insert into #214s_in
    select serial,
      part,
      std_quantity,
      date_stamp
      from audit_trail
      where "type"='Z'
      and custom4=@twofourteen
  insert into #214s_out
    select serial,
      part,
      std_quantity,
      date_stamp,
      custom2
      from audit_trail
      where "type" in('S','D','V')
      and custom4=@twofourteen
  insert into #214s_out
    select serial,
      part,
      std_quantity,
      date_stamp,
      custom2
      from audit_trail
      where "type"='Q'
      and custom4=@twofourteen
      and user_defined_status like 'Scrapped%'
  select Serialin=#214s_in.serial,
    partin=#214s_in.part,
    qtyin=#214s_in.quantity,
    datein=#214s_in.datereceived,
    serialout=#214s_out.serial,
    partout=#214s_out.part,
    qtyout=#214s_out.quantity,
    datoutsystem=#214s_out.dateout,
    part_standard.cost,
    part_standard.price,
    ITNo
    from #214s_in
		left join #214s_out
			on #214s_in.serial=#214s_out.serial
		join part_standard
			on #214s_in.part=part_standard.part
    order by
    partin asc,
    serialin asc
end
GO
