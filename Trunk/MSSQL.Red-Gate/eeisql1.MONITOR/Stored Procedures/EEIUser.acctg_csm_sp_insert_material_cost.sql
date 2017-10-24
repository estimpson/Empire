SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_csm_sp_insert_material_cost] 
     @base_part varchar(50),      
	 @release_id varchar(15),
	 @row_id int,
     @version varchar(30),
	 @inclusion varchar(50),
	 @partusedforcost varchar(50),

	 @jan_15 decimal(10,4), 
     @feb_15 decimal(10,4), 
     @mar_15 decimal(10,4), 
     @apr_15 decimal(10,4), 
     @may_15 decimal(10,4), 
     @jun_15 decimal(10,4), 
     @jul_15 decimal(10,4), 
     @aug_15 decimal(10,4), 
     @sep_15 decimal(10,4), 
     @oct_15 decimal(10,4), 
     @nov_15 decimal(10,4), 
     @dec_15 decimal(10,4),
     @Total_2015 decimal(10,4),
     
	 @jan_16 decimal(10,4), 
     @feb_16 decimal(10,4), 
     @mar_16 decimal(10,4), 
     @apr_16 decimal(10,4), 
     @may_16 decimal(10,4), 
     @jun_16 decimal(10,4), 
     @jul_16 decimal(10,4), 
     @aug_16 decimal(10,4), 
     @sep_16 decimal(10,4), 
     @oct_16 decimal(10,4), 
     @nov_16 decimal(10,4), 
     @dec_16 decimal(10,4),
     @Total_2016 decimal(10,4),
	      
	 @jan_17 decimal(10,4), 
     @feb_17 decimal(10,4), 
     @mar_17 decimal(10,4), 
     @apr_17 decimal(10,4), 
     @may_17 decimal(10,4), 
     @jun_17 decimal(10,4), 
     @jul_17 decimal(10,4), 
     @aug_17 decimal(10,4), 
     @sep_17 decimal(10,4), 
     @oct_17 decimal(10,4), 
     @nov_17 decimal(10,4), 
     @dec_17 decimal(10,4),
     @Total_2017 decimal(10,4)
as
select @row_id = (select max(row_id)+1 from eeiuser.acctg_csm_material_cost_tabular where base_part = @base_part and release_id = @release_id)

Insert into eeiuser.acctg_csm_material_cost_tabular (release_id, row_id, base_part, version, inclusion, partusedforcost, 
jan_15, feb_15, mar_15, apr_15, may_15, jun_15, jul_15, aug_15, sep_15, oct_15, nov_15, dec_15, 
jan_16, feb_16, mar_16, apr_16, may_16, jun_16, jul_16, aug_16, sep_16, oct_16, nov_16, dec_16,
jan_17, feb_17, mar_17, apr_17, may_17, jun_17, jul_17, aug_17, sep_17, oct_17, nov_17, dec_17)
values (@release_id, @row_id, @base_part, @version, @inclusion, @partusedforcost, 
@jan_15, @feb_15, @mar_15, @apr_15, @may_15, @jun_15, @jul_15, @aug_15, @sep_15, @oct_15, @nov_15, @dec_15, 
@jan_16, @feb_16, @mar_16, @apr_16, @may_16, @jun_16, @jul_16, @aug_16, @sep_16, @oct_16, @nov_16, @dec_16,
@jan_17, @feb_17, @mar_17, @apr_17, @may_17, @jun_17, @jul_17, @aug_17, @sep_17, @oct_17, @nov_17, @dec_17)

GO
