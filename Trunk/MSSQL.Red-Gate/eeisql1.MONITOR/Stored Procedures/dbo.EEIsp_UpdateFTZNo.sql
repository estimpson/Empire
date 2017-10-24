SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[EEIsp_UpdateFTZNo](@location varchar(10),@FTZNo varchar(50),@ITNo varchar(50),@operator varchar(10))

as
begin
  if exists(select 1 from FTZIDs where twofourteenNO=@FTZNo or ITNo=@ITNo)
    begin
      select serial,
        object.part,
        quantity,
        Custom3,
        Custom4,
        location,
        part_standard.material_cum
        from object join
        part_standard on object.part=part_standard.part
        where 1=0
      return
    end
  else
    begin
      insert into FTZIds
        select @FTZNo,
          @ITNo,
          getdate(),
          null,
          null,
          null,
          null
      create table #serialstoupdate(
        serial integer null,
        )
      insert into #serialstoupdate
        select serial
          from object where location=@location
          and  serial not in (select serial from audit_trail where date_stamp>'2005/06/28' and "type"='Z')
      insert into audit_trail(serial,
        date_stamp,
        type,
        part,
        quantity,
        remarks,
        price,
        salesman,
        customer,
        vendor,
        po_number,
        operator,
        from_loc,
        to_loc,
        on_hand,
        lot,
        weight,
        status,
        shipper,
        unit,
        workorder,
        std_quantity,
        cost,
        custom1,
        custom2,
        custom3,
        custom4,
        custom5,
        plant,
        notes,
        gl_account,
        package_type,
        suffix,
        due_date,
        group_no,
        sales_order,
        release_no,
        std_cost,
        user_defined_status,
        engineering_level,
        parent_serial,
        destination,
        sequence,
        object_type,
        part_name,
        start_date,
        field1,
        field2,
        show_on_shipper,
        tare_weight,
        kanban_number,
        dimension_qty_string,
        dim_qty_string_other,
        varying_dimension_code)
        select object.serial,
          getdate(),'Z',
          object.part,
          IsNull(object.quantity,1),'FTZ Entry',
          IsNull(part_standard.price,0),
          null,
          null,
          null,
          null,
          @operator,
          object.location,
          null,
          part_online.on_hand,
          object.lot,
          object.weight,
          object.status,
          null,
          object.unit_measure,
          object.workorder,
          object.std_quantity,
          object.cost,
          object.custom1,
          object.custom2,
          @ITNo,
          @FTZNo,
          object.custom5,
          object.plant,
          object.note,
          null,
          object.package_type,
          object.suffix,
          object.date_due,
          null,
          null,
          null,
          object.std_cost,
          object.user_defined_status,
          object.engineering_level,
          object.parent_serial,
          null,
          object.sequence,
          object.type,
          object.name,
          object.start_date,
          object.field1,
          object.field2,
          object.show_on_shipper,
          object.tare_weight,
          object.kanban_number,
          object.dimension_qty_string,
          object.dim_qty_string_other,
          object.varying_dimension_code
          from object join
          part_standard on object.part=part_standard.part join
          part_online on part_standard.part=part_online.part
          where object.location=@location and serial in (select serial from #serialstoupdate)
      update object set
        custom4=@FTZNo,
        custom3=@ITNo
        where serial in (select serial from #serialstoupdate)
      select serial,
        object.part,
        quantity,
        Custom3,
        Custom4,
        location,
        part_standard.material_cum
        from object join
        part_standard on object.part=part_standard.part
        where serial=any(select serial from #serialstoupdate)
        and object.part<>'PALLET'
    end
end
GO
