SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[acctg_eehsp_rpt_rollup_analysis]

as 

begin


-- clear the rows from the permanent table to allow repopulation

TRUNCATE TABLE		Acctg_Rollup_Analysis


-- Create the table to store the analysis of pre and post rollup part data
	
--CREATE TABLE		Acctg_Rollup_Analysis	(
--									serial_pre				varchar(50),
--									part_pre				varchar(50),
--									quantity_pre			decimal(18,6),
--									type_pre				varchar(50),
--									product_line_pre		varchar(50),
--									material_cum_pre		decimal(18,6),
--									ext_material_cum_pre	decimal(18,6),
--									labor_cum_pre			decimal(18,6),
--									ext_labor_cum_pre		decimal(18,6),
--									burden_cum_pre			decimal(18,6),
--									ext_burden_cum_pre		decimal(18,6),
--									serial_post				varchar(50),
--									part_post				varchar(50),
--									quantity_post			decimal(18,6),
--									type_post				varchar(50),
--									product_line_post		varchar(50),
--									material_cum_post		decimal(18,6),
--									ext_material_cum_post	decimal(18,6),
--									labor_cum_post			decimal(18,6),
--									ext_labor_cum_post		decimal(18,6),
--									burden_cum_post			decimal(18,6),
--									ext_burden_cum_post		decimal(18,6),
--									material_difference		decimal(18,6),
--									ext_material_difference	decimal(18,6),									
--									labor_difference		decimal(18,6),
--									ext_labor_difference	decimal(18,6),
--									burden_difference		decimal(18,6),
--									ext_burden_difference	decimal(18,6)
--									)
--
--CREATE INDEX		idx_Acctg_Rollup_Analysis on Acctg_Rollup_Analysis(part_pre)


-- Populate the table with the pre rollup part data

	Insert			Acctg_Rollup_Analysis (serial_pre, part_pre, quantity_pre, type_pre, 
                                           product_line_pre, material_cum_pre, ext_material_cum_pre,
										   labor_cum_pre, ext_labor_cum_pre, burden_cum_pre, ext_burden_cum_pre, type_post, product_line_post)

		select		object_copy_20060930.serial,
					object_copy_20060930.part,
					object_copy_20060930.quantity,
					part_copy_20060930.type,
					part_copy_20060930.product_line,
					part_standard_copy_20060930.material_cum,
					object_copy_20060930.quantity*part_standard_copy_20060930.material_cum,
					part_standard_copy_20060930.labor_cum,
					object_copy_20060930.quantity*part_standard_copy_20060930.labor_cum,
					part_standard_copy_20060930.burden_cum,
					object_copy_20060930.quantity*part_standard_copy_20060930.burden_cum,
					part_copy_20060930.type,
					part_copy_20060930.product_line

		from		object_copy_20060930

		left outer join part_copy_20060930 on object_copy_20060930.part = part_copy_20060930.part
		left outer join part_standard_copy_20060930 on object_copy_20060930.part = part_standard_copy_20060930.part

		order by 	1


-- Populate the table with the post rollup part data

	Update			Acctg_Rollup_Analysis

		set			serial_post=object_copy_20060930_post.serial,
					part_post=object_copy_20060930_post.part,
					quantity_post=object_copy_20060930_post.quantity,
					type_post=part_copy_20060930_post.type,
					product_line_post=part_copy_20060930_post.product_line,
					material_cum_post=part_standard_copy_20060930_post.material_cum,
					ext_material_cum_post=object_copy_20060930_post.quantity*part_standard_copy_20060930_post.material_cum,
					labor_cum_post=part_standard_copy_20060930_post.labor_cum,
					ext_labor_cum_post=object_copy_20060930_post.quantity*part_standard_copy_20060930_post.labor_cum,
					burden_cum_post=part_standard_copy_20060930_post.burden_cum,
					ext_burden_cum_post=object_copy_20060930_post.quantity*part_standard_copy_20060930_post.burden_cum
		
		from		object_copy_20060930_post, part_copy_20060930_post, part_standard_copy_20060930_post

		where		object_copy_20060930_post.serial = acctg_rollup_analysis.serial_pre
			        and part_copy_20060930_post.part = object_copy_20060930_post.part
					and part_standard_copy_20060930_post.part = object_copy_20060930_post.part



-- Populate the table with the post rollup part data where serial didn't exist in pre rollup part data

	Insert			Acctg_Rollup_Analysis (serial_pre,part_pre,type_pre,product_line_pre,serial_post, part_post, quantity_post, type_post, 
                                           product_line_post, material_cum_post, ext_material_cum_post,
										   labor_cum_post, ext_labor_cum_post, burden_cum_post, ext_burden_cum_post)

		select		object_copy_20060930_post.serial,
					object_copy_20060930_post.part,
					part_copy_20060930_post.type,
					part_copy_20060930_post.product_line,
					object_copy_20060930_post.serial,
					object_copy_20060930_post.part,
					object_copy_20060930_post.quantity,
					part_copy_20060930_post.type,
					part_copy_20060930_post.product_line,
					part_standard_copy_20060930_post.material_cum,
					object_copy_20060930_post.quantity*part_standard_copy_20060930_post.material_cum,
					part_standard_copy_20060930_post.labor_cum,
					object_copy_20060930_post.quantity*part_standard_copy_20060930_post.labor_cum,
					part_standard_copy_20060930_post.burden_cum,
					object_copy_20060930_post.quantity*part_standard_copy_20060930_post.burden_cum

		from		object_copy_20060930_post

		left outer join part_copy_20060930_post on object_copy_20060930_post.part = part_copy_20060930_post.part
		left outer join part_standard_copy_20060930_post on object_copy_20060930_post.part = part_standard_copy_20060930_post.part

		where serial not in (select serial_pre from acctg_rollup_analysis)

		order by 	1


-- Calculate the differences

	Update			Acctg_Rollup_Analysis

		set			material_difference=ISNULL(material_cum_post,0)-ISNULL(material_cum_pre,0),
					ext_material_difference=ISNULL(ext_material_cum_post,0)-ISNULL(ext_material_cum_pre,0),
					labor_difference=ISNULL(labor_cum_post,0)-ISNULL(labor_cum_pre,0),
					ext_labor_difference=ISNULL(ext_labor_cum_post,0)-ISNULL(ext_labor_cum_pre,0),
					burden_difference=ISNULL(burden_cum_post,0)-ISNULL(burden_cum_pre,0),
					ext_burden_difference=ISNULL(ext_burden_cum_post,0)-ISNULL(ext_burden_cum_pre,0)

End

GO
