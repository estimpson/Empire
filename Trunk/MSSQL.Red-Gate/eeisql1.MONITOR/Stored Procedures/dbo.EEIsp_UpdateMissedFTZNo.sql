SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- exec dbo.eeisp_UpdateMissedFTZNO 'EEH-15104', '984900644', 'V0C00184483', 'RET'


CREATE procedure [dbo].[EEIsp_UpdateMissedFTZNo](@shipper varchar(20),@FTZNo varchar(50),@ITNo varchar(50),@operator varchar(10))

as
begin
      create table #serialstoupdate(
        serial integer null,
        )

      insert into #serialstoupdate
        select serial
          from audit_trail where shipper = @shipper 
		  and type = 'R'
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
        flag,
		activity,
		unit,
        workorder,
        std_quantity,
        cost,
		control_number,
        custom1,
        custom2,
        custom3,
        custom4,
        custom5,
        plant,
		invoice_number,
        notes,
        gl_account,
        package_type,
        suffix,
        due_date,
        group_no,
        sales_order,
        release_no,
		dropship_shipper,
        std_cost,
        user_defined_status,
        engineering_level,
        parent_serial,
		origin,
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
        varying_dimension_code,
		invoice,
		invoice_line)
        select serial,
          dateadd(hour,1,date_stamp),
		  'Z',
          at.part,
          IsNull(at.quantity,0),
		  'FTZ Entry',
          IsNull(at.price,0),
          salesman,
          customer,
		  vendor,
		  po_number,
          @operator,
          to_loc,
          to_loc,
          part_online.on_hand,
          lot,
          weight,
          status,
          shipper,
          flag,
		  activity,
		  unit,
          workorder,
          std_quantity,
          cost,
		  control_number,
          custom1,
          custom2,
          @ITNo,
          @FTZNo,
          custom5,
          plant,
		  invoice_number,
		  notes, 
		  gl_account,
          package_type,
          suffix,
          due_date,
          group_no,
          sales_order,
          release_no,
		  dropship_shipper,
		  std_cost,
          user_defined_status,
          engineering_level,
          parent_serial,
          origin,
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
          varying_dimension_code,
		  invoice,
		  invoice_line
          from audit_trail at
          left join part_online on at.part=part_online.part
          where at.shipper = @shipper and serial in (select serial from #serialstoupdate) and type = 'R'
      
	  update audit_trail 
		set	custom4=@FTZNo,
			custom3=@ITNo
		where serial in (select serial from #serialstoupdate) and type not in ('R','U','A')
	
		
	  update object 
	   set	 custom4=@FTZNo,
			 custom3=@ITNo
       where serial in (select serial from #serialstoupdate)
		
	 select	serial,
			object.part,
			quantity,
			Custom3,
			Custom4,
			location,
			part_standard.material_cum
			from object join
			part_standard on object.part=part_standard.part
			where	serial=any(select serial from #serialstoupdate)
				and object.part<>'PALLET'
    end


GO
