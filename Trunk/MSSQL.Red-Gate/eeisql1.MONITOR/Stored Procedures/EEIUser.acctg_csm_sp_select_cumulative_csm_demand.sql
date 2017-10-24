SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec eeiuser.acctg_csm_sp_select_cumulative_csm_demand '2008-01', 'ALC0001'

CREATE procedure [EEIUser].[acctg_csm_sp_select_cumulative_csm_demand] @release_id varchar(50), @base_part varchar(50)
as

create table #b(
base_part varchar(50),
mnemonic varchar(50))

insert into #b
select base_part, mnemonic 
from eeiuser.acctg_csm_base_part_mnemonic
where base_part = @base_part and take_rate <> 0 and family_allocation <> 0

create table #a(
periodid int,
fiscal_year int,
period int,
month_year varchar(10),
demand decimal(10,2))


insert into #a
select '200401', '2004','01', 'Jan-04', sum(jan_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select '200402', '2004','02', 'Feb-04', sum(feb_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select '200403', '2004','03', 'Mar-04', sum(mar_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select '200404', '2004','04', 'Apr-04', sum(apr_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200405, '2004','05', 'May-04', sum(may_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200406, '2004','06', 'Jun-04', sum(jun_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200407, '2004','07', 'Jul-04', sum(jul_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200408, '2004','08', 'Aug-04', sum(aug_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200409, '2004','09', 'Sep-04', sum(sep_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200410, '2004','10', 'Oct-04', sum(oct_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200411, '2004','11', 'Nov-04', sum(nov_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200412, '2004','12', 'Dec-04', sum(dec_04) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200501, '2005','01', 'Jan-05', sum(jan_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200502, '2005','02', 'Feb-05', sum(feb_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200503, '2005','03', 'Mar-05', sum(mar_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200504, '2005','04', 'Apr-05', sum(apr_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200505, '2005','05', 'May-05', sum(may_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200506, '2005','06', 'Jun-05', sum(jun_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200507, '2005','07', 'Jul-05', sum(jul_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200508, '2005','08', 'Aug-05', sum(aug_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200509, '2005','09', 'Sep-05', sum(sep_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200510, '2005','10', 'Oct-05', sum(oct_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200511, '2005','11', 'Nov-05', sum(nov_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200512, '2005','12', 'Dec-05', sum(dec_05) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200601, '2006','01', 'Jan-06', sum(jan_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200602, '2006','02', 'Feb-06', sum(feb_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200603, '2006','03', 'Mar-06', sum(mar_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200604, '2006','04', 'Apr-06', sum(apr_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200605, '2006','05', 'May-06', sum(may_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200606, '2006','06', 'Jun-06', sum(jun_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200607, '2006','07', 'Jul-06', sum(jul_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200608, '2006','08', 'Aug-06', sum(aug_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200609, '2006','09', 'Sep-06', sum(sep_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200610, '2006','10', 'Oct-06', sum(oct_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200611, '2006','11', 'Nov-06', sum(nov_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200612, '2006','12', 'Dec-06', sum(dec_06) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200701, '2007','01', 'Jan-07', sum(jan_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200702, '2007','02', 'Feb-07', sum(feb_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200703, '2007','03', 'Mar-07', sum(mar_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200704, '2007','04', 'Apr-07', sum(apr_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200705, '2007','05', 'May-07', sum(may_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200706, '2007','06', 'Jun-07', sum(jun_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200707, '2007','07', 'Jul-07', sum(jul_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200708, '2007','08', 'Aug-07', sum(aug_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200709, '2007','09', 'Sep-07', sum(sep_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200710, '2007','10', 'Oct-07', sum(oct_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200711, '2007','11', 'Nov-07', sum(nov_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200712, '2007','12', 'Dec-07', sum(dec_07) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200801, '2008','01', 'Jan-08', sum(jan_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200802, '2008','02', 'Feb-08', sum(feb_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200803, '2008','03', 'Mar-08', sum(mar_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200804, '2008','04', 'Apr-08', sum(apr_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200805, '2008','05', 'May-08', sum(may_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200806, '2008','06', 'Jun-08', sum(jun_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200807, '2008','07', 'Jul-08', sum(jul_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200808, '2008','08', 'Aug-08', sum(aug_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200809, '2008','09', 'Sep-08', sum(sep_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200810, '2008','10', 'Oct-08', sum(oct_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200811, '2008','11', 'Nov-08', sum(nov_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200812, '2008','12', 'Dec-08', sum(dec_08) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200901, '2009','01', 'Jan-09', sum(jan_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200902, '2009','02', 'Feb-09', sum(feb_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200903, '2009','03', 'Mar-09', sum(mar_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200904, '2009','04', 'Apr-09', sum(apr_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200905, '2009','05', 'May-09', sum(may_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200906, '2009','06', 'Jun-09', sum(jun_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200907, '2009','07', 'Jul-09', sum(jul_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200908, '2009','08', 'Aug-09', sum(aug_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200909, '2009','09', 'Sep-09', sum(sep_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200910, '2009','10', 'Oct-10', sum(oct_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200911, '2009','11', 'Nov-11', sum(nov_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)
insert into #a
select 200912, '2009','12', 'Dec-12', sum(dec_09) as demand from eeiuser.acctg_csm_nacsm where release_id = @release_id and mnemonic in (select mnemonic from #b)

select * from #b

select 
a1.month_year,
a1.demand, 
a1.demand+COALESCE((select sum(demand) from #a a2 where a2.periodid < a1.periodid),0) as runningtotal
from #a a1
order by a1.periodid


































GO
