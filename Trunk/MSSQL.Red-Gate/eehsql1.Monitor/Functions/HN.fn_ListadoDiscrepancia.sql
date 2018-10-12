SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [HN].[fn_ListadoDiscrepancia](
	@FechaInicio datetime, 
	@FechaFinal datetime)
returns @Result table (
	Serial int NOT NULL,
	Operator varchar(5) NOT NULL,
	TranDate datetime NULL,
	Location varchar(10) NULL,
	Part varchar(25) NOT NULL,
	Remarks varchar(10) NOT NULL,
	QtyLost numeric(38, 6) NULL,
	CostLost numeric(38, 9) NULL,
	QtyFound numeric(38, 6) NULL,
	CostFound numeric(38, 9) NULL,
	Cost numeric(38, 9) NULL,
	Notas varchar(254) NULL,
	OperationType varchar(11) NOT NULL,
	GroupNo varchar(25) null)

as 

begin 
insert into @Result(Serial, Operator, TranDate, Location, Part, Remarks, QtyLost,
            CostLost, QtyFound, CostFound, Cost, Notas, OperationType, GroupNo)
select	Serial, Operator, TranDate, Location, Part, Remarks, QtyLost,
            CostLost, QtyFound, CostFound, Cost, Notas, OperationType, GroupNo
from (
select      Serial = serial,
        Operator = operator,
        TranDate = dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        Location = from_loc,
        Part = at.part,
        Remarks = remarks,
        QtyLost = sum (Case when quantity > 0 then quantity else 0 end ),
        CostLost = sum (Case when quantity > 0 then quantity * material_cum else 0 end ),
        QtyFound = sum (Case when quantity < 0 then quantity else 0 end ),
        CostFound = sum (Case when quantity < 0 then quantity * material_cum else 0 end ),
        Cost = sum (quantity * material_cum),
        Notas = at.notes,
        OperationType = 'Cycle Count',
        GroupNo = (select Group_no from location where code  = from_loc)
from  audit_trail at join part_standard on at.part = part_standard.part
where at.type='E' 
            and   remarks in ('Qty Excess', 'Qty Discr', 'Qty Lost', 'Qty found') 
            and   date_stamp between @FechaInicio and @FechaFinal
            and quantity != 0 
            and (at.notes like 'Quantity excess during cycle count in%')
group by
        serial,
       operator,
        from_loc,
        at.part,
        dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        remarks,
        at.notes
--order by 2,3,1
union all
select      Serial = serial,
        Operator = operator,
        TranDate = dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        Location = from_loc,
        Part = at.part,
        Remarks = remarks,
        QtyLost = sum (Case when quantity > 0 then quantity else 0 end ),
        CostLost = sum (Case when quantity > 0 then quantity * material_cum else 0 end ),
        QtyFound = sum (Case when quantity < 0 then quantity else 0 end ),
        CostFound = sum (Case when quantity < 0 then quantity * material_cum else 0 end ),
        Cost = sum (quantity * material_cum),
        Notas = at.notes, 
        OperationType = 'Cycle Count',
        GroupNo = (select Group_no from location where code  = from_loc)
from  audit_trail at join part_standard on at.part = part_standard.part
where at.type='E' 
            and   remarks in ('Qty Excess', 'Qty Discr', 'Qty Lost', 'Qty found') 
            and   date_stamp between @FechaInicio and @FechaFinal
            and quantity != 0 
            and (at.notes like 'Quantity short during cycle count in%')
group by
        serial,
       operator,
        from_loc,
        at.part,
        dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        remarks,
        at.notes
--order by 2,3,1
union all
select      Serial = serial,
        Operator = operator,
        TranDate = dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        Location = from_loc,
        Part = at.part,
        Remarks = remarks,
        QtyLost = sum (Case when quantity > 0 then quantity else 0 end ),
        CostLost = sum (Case when quantity > 0 then quantity * material_cum else 0 end ),
        QtyFound = sum (Case when quantity < 0 then quantity else 0 end ),
        CostFound = sum (Case when quantity < 0 then quantity * material_cum else 0 end ),
        Cost = sum (quantity * material_cum),
        Notas = at.notes,
        OperationType = 'Adjust',
        GroupNo = (select Group_no from location where code  = from_loc)
from  audit_trail at join part_standard on at.part = part_standard.part
where at.type='E' 
            and   remarks in ('Qty Excess', 'Qty Discr', 'Qty Lost', 'Qty found') 
            and   date_stamp between @FechaInicio and @FechaFinal
            and quantity != 0 
            and (at.notes like 'Quantity excess during adjust%')
group by 
        serial,
       operator,
        from_loc,
        at.part,
        dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        remarks,
        at.notes
--order by 2,3,1
union all
select      Serial = serial,
        Operator = operator,
        TranDate = dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        Location = from_loc,
        Part = at.part,
        Remarks = remarks,
        QtyLost = sum (Case when quantity > 0 then quantity else 0 end ),
        CostLost = sum (Case when quantity > 0 then quantity * material_cum else 0 end ),
        QtyFound = sum (Case when quantity < 0 then quantity else 0 end ),
        CostFound = sum (Case when quantity < 0 then quantity * material_cum else 0 end ),
        Cost = sum (quantity * material_cum),
        Notas = at.notes,
        OperationType = 'Adjust',
        GroupNo = (select Group_no from location where code  = from_loc)
from  audit_trail at join part_standard on at.part = part_standard.part
where at.type='E' 
            and   remarks in ('Qty Excess', 'Qty Discr', 'Qty Lost', 'Qty found') 
            and   date_stamp between @FechaInicio and @FechaFinal
            and quantity != 0 
            and (at.notes like 'Quantity short during adjust%')
group by
        serial,
       operator,
        from_loc,
        at.part,
        dateadd (day, datediff (day, '2008-01-01', date_stamp), '2008-01-01'),
        remarks,
        at.notes
--order by 2,3,1
) x

return
end
GO
