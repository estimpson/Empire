SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE proc [EEIUser].[acctg_csm_sp_select_base_part_new_sales_award] (@base_part varchar(30)) 
as 

--For Testing:

-- exec eeiuser.acctg_csm_sp_select_base_part_new_sales_award @base_part = 'TRW1152' 


--declare @base_part varchar(20)
--declare @release_id varchar(8)
--select @base_part = 'TRW1152' 
--select @release_id = '2018-10'

select	Salesman, 
		[Program Manager], 
		[Date of Program Award], 
		[Form of Customer Commitment], 
		[Date Added to MSF],
		[Customer Code], 
		[Customer Part Number], 
		[New Business Type], 
		[Replacing Empire Part Number], 
		[OEM], 
		[Vehicle Program], 
		[Vehicle Name], 
		[SOP Date], 
		[EOP Date], 
		[Application], 
		[Qty Per Vehicle], 
		[Customer Annual Capacity Planning Volume], 
		[Quote Number], 
		[Quote Date], 
		[Quoted EAU], 
		[MOQ], 
		[Quoted Selling Price], 
		[Quoted Material Cost], 
		(case when isnull([Quoted Selling Price],0)=0 then 0 else [Quoted Material Cost]/[Quoted Selling Price] end) as [Quoted MC %],
		[Quoted LTA Commitment], 
		[Amortization],
		[Amount of Tooling PO],
		[Tooling Description], 
		[Budget Capex ID] as [Capex ID], 
		[Empire Ship From Location], 
		[Freight Terms], 
		[Customer Ship to Location], 
		[Comments]
from	eeiuser.acctg_sales_new_sales_awards
where	[Empire Part Number] = @base_part

GO
