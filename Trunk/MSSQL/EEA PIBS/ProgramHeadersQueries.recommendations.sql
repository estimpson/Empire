CREATE STATISTICS [_dta_stat_983674552_5_17_1] ON [dbo].[shipper]([status], [type], [id])
go

CREATE STATISTICS [_dta_stat_946102411_1_3] ON [dbo].[part_machine]([part], [sequence])
go

CREATE STATISTICS [_dta_stat_1469248289_3_1_7] ON [dbo].[shipper_detail]([qty_required], [shipper], [order_no])
go

CREATE STATISTICS [_dta_stat_1259867555_2_14_43_16_26] ON [dbo].[order_detail]([part_number], [due_date], [id], [destination], [std_qty])
go

CREATE STATISTICS [_dta_stat_1259867555_2_5_14_3_43_16] ON [dbo].[order_detail]([part_number], [quantity], [due_date], [type], [id], [destination])
go

CREATE STATISTICS [_dta_stat_1291867669_6_1_5_2] ON [dbo].[order_header]([blanket_part], [order_no], [destination], [customer])
go

