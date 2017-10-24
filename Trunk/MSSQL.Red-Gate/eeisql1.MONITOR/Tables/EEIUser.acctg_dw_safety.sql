CREATE TABLE [EEIUser].[acctg_dw_safety]
(
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Core Nameplate Region Mnemonic] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Core Nameplate Plant Mnemonic] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonic-Vehicle] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonic-Vehicle/Plant] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Mnemonic-Platform] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Market] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plant] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plant State/Province] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source Plant] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source Plant Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source Plant Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Design Parent] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Engineering Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturing Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manufacturer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales Parent] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Brand] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform Design Owner] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Architecture] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Platform] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [datetime] NULL,
[EOP] [datetime] NULL,
[Lifecycle (Time)] [int] NULL,
[Vehicle] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Assembly Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Strategic Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales Group] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Nameplate] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Design Center] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Design Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary Design Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary Design Center] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary Design Country] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Secondary Design Region] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GVW Rating] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GVW Class] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Car/Truck] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Production Type] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Production Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Regional Sales Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Production Price Class] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Sales Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Sales Sub-Segment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Global Sales Price Class] [int] NULL,
[Short Term Risk Rating] [int] NULL,
[Long Term Risk Rating] [int] NULL,
[Jan 2000] [decimal] (10, 2) NULL,
[Feb 2000] [decimal] (10, 2) NULL,
[Mar 2000] [decimal] (10, 2) NULL,
[Apr 2000] [decimal] (10, 2) NULL,
[May 2000] [decimal] (10, 2) NULL,
[Jun 2000] [decimal] (10, 2) NULL,
[Jul 2000] [decimal] (10, 2) NULL,
[Aug 2000] [decimal] (10, 2) NULL,
[Sep 2000] [decimal] (10, 2) NULL,
[Oct 2000] [decimal] (10, 2) NULL,
[Nov 2000] [decimal] (10, 2) NULL,
[Dec 2000] [decimal] (10, 2) NULL,
[Jan 2001] [decimal] (10, 2) NULL,
[Feb 2001] [decimal] (10, 2) NULL,
[Mar 2001] [decimal] (10, 2) NULL,
[Apr 2001] [decimal] (10, 2) NULL,
[May 2001] [decimal] (10, 2) NULL,
[Jun 2001] [decimal] (10, 2) NULL,
[Jul 2001] [decimal] (10, 2) NULL,
[Aug 2001] [decimal] (10, 2) NULL,
[Sep 2001] [decimal] (10, 2) NULL,
[Oct 2001] [decimal] (10, 2) NULL,
[Nov 2001] [decimal] (10, 2) NULL,
[Dec 2001] [decimal] (10, 2) NULL,
[Jan 2002] [decimal] (10, 2) NULL,
[Feb 2002] [decimal] (10, 2) NULL,
[Mar 2002] [decimal] (10, 2) NULL,
[Apr 2002] [decimal] (10, 2) NULL,
[May 2002] [decimal] (10, 2) NULL,
[Jun 2002] [decimal] (10, 2) NULL,
[Jul 2002] [decimal] (10, 2) NULL,
[Aug 2002] [decimal] (10, 2) NULL,
[Sep 2002] [decimal] (10, 2) NULL,
[Oct 2002] [decimal] (10, 2) NULL,
[Nov 2002] [decimal] (10, 2) NULL,
[Dec 2002] [decimal] (10, 2) NULL,
[Jan 2003] [decimal] (10, 2) NULL,
[Feb 2003] [decimal] (10, 2) NULL,
[Mar 2003] [decimal] (10, 2) NULL,
[Apr 2003] [decimal] (10, 2) NULL,
[May 2003] [decimal] (10, 2) NULL,
[Jun 2003] [decimal] (10, 2) NULL,
[Jul 2003] [decimal] (10, 2) NULL,
[Aug 2003] [decimal] (10, 2) NULL,
[Sep 2003] [decimal] (10, 2) NULL,
[Oct 2003] [decimal] (10, 2) NULL,
[Nov 2003] [decimal] (10, 2) NULL,
[Dec 2003] [decimal] (10, 2) NULL,
[Jan 2004] [decimal] (10, 2) NULL,
[Feb 2004] [decimal] (10, 2) NULL,
[Mar 2004] [decimal] (10, 2) NULL,
[Apr 2004] [decimal] (10, 2) NULL,
[May 2004] [decimal] (10, 2) NULL,
[Jun 2004] [decimal] (10, 2) NULL,
[Jul 2004] [decimal] (10, 2) NULL,
[Aug 2004] [decimal] (10, 2) NULL,
[Sep 2004] [decimal] (10, 2) NULL,
[Oct 2004] [decimal] (10, 2) NULL,
[Nov 2004] [decimal] (10, 2) NULL,
[Dec 2004] [decimal] (10, 2) NULL,
[Jan 2005] [decimal] (10, 2) NULL,
[Feb 2005] [decimal] (10, 2) NULL,
[Mar 2005] [decimal] (10, 2) NULL,
[Apr 2005] [decimal] (10, 2) NULL,
[May 2005] [decimal] (10, 2) NULL,
[Jun 2005] [decimal] (10, 2) NULL,
[Jul 2005] [decimal] (10, 2) NULL,
[Aug 2005] [decimal] (10, 2) NULL,
[Sep 2005] [decimal] (10, 2) NULL,
[Oct 2005] [decimal] (10, 2) NULL,
[Nov 2005] [decimal] (10, 2) NULL,
[Dec 2005] [decimal] (10, 2) NULL,
[Jan 2006] [decimal] (10, 2) NULL,
[Feb 2006] [decimal] (10, 2) NULL,
[Mar 2006] [decimal] (10, 2) NULL,
[Apr 2006] [decimal] (10, 2) NULL,
[May 2006] [decimal] (10, 2) NULL,
[Jun 2006] [decimal] (10, 2) NULL,
[Jul 2006] [decimal] (10, 2) NULL,
[Aug 2006] [decimal] (10, 2) NULL,
[Sep 2006] [decimal] (10, 2) NULL,
[Oct 2006] [decimal] (10, 2) NULL,
[Nov 2006] [decimal] (10, 2) NULL,
[Dec 2006] [decimal] (10, 2) NULL,
[Jan 2007] [decimal] (10, 2) NULL,
[Feb 2007] [decimal] (10, 2) NULL,
[Mar 2007] [decimal] (10, 2) NULL,
[Apr 2007] [decimal] (10, 2) NULL,
[May 2007] [decimal] (10, 2) NULL,
[Jun 2007] [decimal] (10, 2) NULL,
[Jul 2007] [decimal] (10, 2) NULL,
[Aug 2007] [decimal] (10, 2) NULL,
[Sep 2007] [decimal] (10, 2) NULL,
[Oct 2007] [decimal] (10, 2) NULL,
[Nov 2007] [decimal] (10, 2) NULL,
[Dec 2007] [decimal] (10, 2) NULL,
[Jan 2008] [decimal] (10, 2) NULL,
[Feb 2008] [decimal] (10, 2) NULL,
[Mar 2008] [decimal] (10, 2) NULL,
[Apr 2008] [decimal] (10, 2) NULL,
[May 2008] [decimal] (10, 2) NULL,
[Jun 2008] [decimal] (10, 2) NULL,
[Jul 2008] [decimal] (10, 2) NULL,
[Aug 2008] [decimal] (10, 2) NULL,
[Sep 2008] [decimal] (10, 2) NULL,
[Oct 2008] [decimal] (10, 2) NULL,
[Nov 2008] [decimal] (10, 2) NULL,
[Dec 2008] [decimal] (10, 2) NULL,
[Jan 2009] [decimal] (10, 2) NULL,
[Feb 2009] [decimal] (10, 2) NULL,
[Mar 2009] [decimal] (10, 2) NULL,
[Apr 2009] [decimal] (10, 2) NULL,
[May 2009] [decimal] (10, 2) NULL,
[Jun 2009] [decimal] (10, 2) NULL,
[Jul 2009] [decimal] (10, 2) NULL,
[Aug 2009] [decimal] (10, 2) NULL,
[Sep 2009] [decimal] (10, 2) NULL,
[Oct 2009] [decimal] (10, 2) NULL,
[Nov 2009] [decimal] (10, 2) NULL,
[Dec 2009] [decimal] (10, 2) NULL,
[Jan 2010] [decimal] (10, 2) NULL,
[Feb 2010] [decimal] (10, 2) NULL,
[Mar 2010] [decimal] (10, 2) NULL,
[Apr 2010] [decimal] (10, 2) NULL,
[May 2010] [decimal] (10, 2) NULL,
[Jun 2010] [decimal] (10, 2) NULL,
[Jul 2010] [decimal] (10, 2) NULL,
[Aug 2010] [decimal] (10, 2) NULL,
[Sep 2010] [decimal] (10, 2) NULL,
[Oct 2010] [decimal] (10, 2) NULL,
[Nov 2010] [decimal] (10, 2) NULL,
[Dec 2010] [decimal] (10, 2) NULL,
[Jan 2011] [decimal] (10, 2) NULL,
[Feb 2011] [decimal] (10, 2) NULL,
[Mar 2011] [decimal] (10, 2) NULL,
[Apr 2011] [decimal] (10, 2) NULL,
[May 2011] [decimal] (10, 2) NULL,
[Jun 2011] [decimal] (10, 2) NULL,
[Jul 2011] [decimal] (10, 2) NULL,
[Aug 2011] [decimal] (10, 2) NULL,
[Sep 2011] [decimal] (10, 2) NULL,
[Oct 2011] [decimal] (10, 2) NULL,
[Nov 2011] [decimal] (10, 2) NULL,
[Dec 2011] [decimal] (10, 2) NULL,
[Jan 2012] [decimal] (10, 2) NULL,
[Feb 2012] [decimal] (10, 2) NULL,
[Mar 2012] [decimal] (10, 2) NULL,
[Apr 2012] [decimal] (10, 2) NULL,
[May 2012] [decimal] (10, 2) NULL,
[Jun 2012] [decimal] (10, 2) NULL,
[Jul 2012] [decimal] (10, 2) NULL,
[Aug 2012] [decimal] (10, 2) NULL,
[Sep 2012] [decimal] (10, 2) NULL,
[Oct 2012] [decimal] (10, 2) NULL,
[Nov 2012] [decimal] (10, 2) NULL,
[Dec 2012] [decimal] (10, 2) NULL,
[Jan 2013] [decimal] (10, 2) NULL,
[Feb 2013] [decimal] (10, 2) NULL,
[Mar 2013] [decimal] (10, 2) NULL,
[Apr 2013] [decimal] (10, 2) NULL,
[May 2013] [decimal] (10, 2) NULL,
[Jun 2013] [decimal] (10, 2) NULL,
[Jul 2013] [decimal] (10, 2) NULL,
[Aug 2013] [decimal] (10, 2) NULL,
[Sep 2013] [decimal] (10, 2) NULL,
[Oct 2013] [decimal] (10, 2) NULL,
[Nov 2013] [decimal] (10, 2) NULL,
[Dec 2013] [decimal] (10, 2) NULL,
[Jan 2014] [decimal] (10, 2) NULL,
[Feb 2014] [decimal] (10, 2) NULL,
[Mar 2014] [decimal] (10, 2) NULL,
[Apr 2014] [decimal] (10, 2) NULL,
[May 2014] [decimal] (10, 2) NULL,
[Jun 2014] [decimal] (10, 2) NULL,
[Jul 2014] [decimal] (10, 2) NULL,
[Aug 2014] [decimal] (10, 2) NULL,
[Sep 2014] [decimal] (10, 2) NULL,
[Oct 2014] [decimal] (10, 2) NULL,
[Nov 2014] [decimal] (10, 2) NULL,
[Dec 2014] [decimal] (10, 2) NULL,
[Jan 2015] [decimal] (10, 2) NULL,
[Feb 2015] [decimal] (10, 2) NULL,
[Mar 2015] [decimal] (10, 2) NULL,
[Apr 2015] [decimal] (10, 2) NULL,
[May 2015] [decimal] (10, 2) NULL,
[Jun 2015] [decimal] (10, 2) NULL,
[Jul 2015] [decimal] (10, 2) NULL,
[Aug 2015] [decimal] (10, 2) NULL,
[Sep 2015] [decimal] (10, 2) NULL,
[Oct 2015] [decimal] (10, 2) NULL,
[Nov 2015] [decimal] (10, 2) NULL,
[Dec 2015] [decimal] (10, 2) NULL,
[Jan 2016] [decimal] (10, 2) NULL,
[Feb 2016] [decimal] (10, 2) NULL,
[Mar 2016] [decimal] (10, 2) NULL,
[Apr 2016] [decimal] (10, 2) NULL,
[May 2016] [decimal] (10, 2) NULL,
[Jun 2016] [decimal] (10, 2) NULL,
[Jul 2016] [decimal] (10, 2) NULL,
[Aug 2016] [decimal] (10, 2) NULL,
[Sep 2016] [decimal] (10, 2) NULL,
[Oct 2016] [decimal] (10, 2) NULL,
[Nov 2016] [decimal] (10, 2) NULL,
[Dec 2016] [decimal] (10, 2) NULL,
[Jan 2017] [decimal] (10, 2) NULL,
[Feb 2017] [decimal] (10, 2) NULL,
[Mar 2017] [decimal] (10, 2) NULL,
[Apr 2017] [decimal] (10, 2) NULL,
[May 2017] [decimal] (10, 2) NULL,
[Jun 2017] [decimal] (10, 2) NULL,
[Jul 2017] [decimal] (10, 2) NULL,
[Aug 2017] [decimal] (10, 2) NULL,
[Sep 2017] [decimal] (10, 2) NULL,
[Oct 2017] [decimal] (10, 2) NULL,
[Nov 2017] [decimal] (10, 2) NULL,
[Dec 2017] [decimal] (10, 2) NULL,
[Jan 2018] [decimal] (10, 2) NULL,
[Feb 2018] [decimal] (10, 2) NULL,
[Mar 2018] [decimal] (10, 2) NULL,
[Apr 2018] [decimal] (10, 2) NULL,
[May 2018] [decimal] (10, 2) NULL,
[Jun 2018] [decimal] (10, 2) NULL,
[Jul 2018] [decimal] (10, 2) NULL,
[Aug 2018] [decimal] (10, 2) NULL,
[Sep 2018] [decimal] (10, 2) NULL,
[Oct 2018] [decimal] (10, 2) NULL,
[Nov 2018] [decimal] (10, 2) NULL,
[Dec 2018] [decimal] (10, 2) NULL,
[Jan 2019] [decimal] (10, 2) NULL,
[Feb 2019] [decimal] (10, 2) NULL,
[Mar 2019] [decimal] (10, 2) NULL,
[Apr 2019] [decimal] (10, 2) NULL,
[May 2019] [decimal] (10, 2) NULL,
[Jun 2019] [decimal] (10, 2) NULL,
[Jul 2019] [decimal] (10, 2) NULL,
[Aug 2019] [decimal] (10, 2) NULL,
[Sep 2019] [decimal] (10, 2) NULL,
[Oct 2019] [decimal] (10, 2) NULL,
[Nov 2019] [decimal] (10, 2) NULL,
[Dec 2019] [decimal] (10, 2) NULL,
[Q1 2008] [decimal] (10, 2) NULL,
[Q2 2008] [decimal] (10, 2) NULL,
[Q3 2008] [decimal] (10, 2) NULL,
[Q4 2008] [decimal] (10, 2) NULL,
[Q1 2009] [decimal] (10, 2) NULL,
[Q2 2009] [decimal] (10, 2) NULL,
[Q3 2009] [decimal] (10, 2) NULL,
[Q4 2009] [decimal] (10, 2) NULL,
[Q1 2010] [decimal] (10, 2) NULL,
[Q2 2010] [decimal] (10, 2) NULL,
[Q3 2010] [decimal] (10, 2) NULL,
[Q4 2010] [decimal] (10, 2) NULL,
[Q1 2011] [decimal] (10, 2) NULL,
[Q2 2011] [decimal] (10, 2) NULL,
[Q3 2011] [decimal] (10, 2) NULL,
[Q4 2011] [decimal] (10, 2) NULL,
[Q1 2012] [decimal] (10, 2) NULL,
[Q2 2012] [decimal] (10, 2) NULL,
[Q3 2012] [decimal] (10, 2) NULL,
[Q4 2012] [decimal] (10, 2) NULL,
[Q1 2013] [decimal] (10, 2) NULL,
[Q2 2013] [decimal] (10, 2) NULL,
[Q3 2013] [decimal] (10, 2) NULL,
[Q4 2013] [decimal] (10, 2) NULL,
[Q1 2014] [decimal] (10, 2) NULL,
[Q2 2014] [decimal] (10, 2) NULL,
[Q3 2014] [decimal] (10, 2) NULL,
[Q4 2014] [decimal] (10, 2) NULL,
[Q1 2015] [decimal] (10, 2) NULL,
[Q2 2015] [decimal] (10, 2) NULL,
[Q3 2015] [decimal] (10, 2) NULL,
[Q4 2015] [decimal] (10, 2) NULL,
[Q1 2016] [decimal] (10, 2) NULL,
[Q2 2016] [decimal] (10, 2) NULL,
[Q3 2016] [decimal] (10, 2) NULL,
[Q4 2016] [decimal] (10, 2) NULL,
[Q1 2017] [decimal] (10, 2) NULL,
[Q2 2017] [decimal] (10, 2) NULL,
[Q3 2017] [decimal] (10, 2) NULL,
[Q4 2017] [decimal] (10, 2) NULL,
[Q1 2018] [decimal] (10, 2) NULL,
[Q2 2018] [decimal] (10, 2) NULL,
[Q3 2018] [decimal] (10, 2) NULL,
[Q4 2018] [decimal] (10, 2) NULL,
[Q1 2019] [decimal] (10, 2) NULL,
[Q2 2019] [decimal] (10, 2) NULL,
[Q3 2019] [decimal] (10, 2) NULL,
[Q4 2019] [decimal] (10, 2) NULL,
[Q1 2020] [decimal] (10, 2) NULL,
[Q2 2020] [decimal] (10, 2) NULL,
[Q3 2020] [decimal] (10, 2) NULL,
[Q4 2020] [decimal] (10, 2) NULL,
[Q1 2021] [decimal] (10, 2) NULL,
[Q2 2021] [decimal] (10, 2) NULL,
[Q3 2021] [decimal] (10, 2) NULL,
[Q4 2021] [decimal] (10, 2) NULL,
[Q1 2022] [decimal] (10, 2) NULL,
[Q2 2022] [decimal] (10, 2) NULL,
[Q3 2022] [decimal] (10, 2) NULL,
[Q4 2022] [decimal] (10, 2) NULL,
[Q1 2023] [decimal] (10, 2) NULL,
[Q2 2023] [decimal] (10, 2) NULL,
[Q3 2023] [decimal] (10, 2) NULL,
[Q4 2023] [decimal] (10, 2) NULL,
[Q1 2024] [decimal] (10, 2) NULL,
[Q2 2024] [decimal] (10, 2) NULL,
[Q3 2024] [decimal] (10, 2) NULL,
[Q4 2024] [decimal] (10, 2) NULL,
[CY 2000] [decimal] (10, 2) NULL,
[CY 2001] [decimal] (10, 2) NULL,
[CY 2002] [decimal] (10, 2) NULL,
[CY 2003] [decimal] (10, 2) NULL,
[CY 2004] [decimal] (10, 2) NULL,
[CY 2005] [decimal] (10, 2) NULL,
[CY 2006] [decimal] (10, 2) NULL,
[CY 2007] [decimal] (10, 2) NULL,
[CY 2008] [decimal] (10, 2) NULL,
[CY 2009] [decimal] (10, 2) NULL,
[CY 2010] [decimal] (10, 2) NULL,
[CY 2011] [decimal] (10, 2) NULL,
[CY 2012] [decimal] (10, 2) NULL,
[CY 2013] [decimal] (10, 2) NULL,
[CY 2014] [decimal] (10, 2) NULL,
[CY 2015] [decimal] (10, 2) NULL,
[CY 2016] [decimal] (10, 2) NULL,
[CY 2017] [decimal] (10, 2) NULL,
[CY 2018] [decimal] (10, 2) NULL,
[CY 2019] [decimal] (10, 2) NULL,
[CY 2020] [decimal] (10, 2) NULL,
[CY 2021] [decimal] (10, 2) NULL,
[CY 2022] [decimal] (10, 2) NULL,
[CY 2023] [decimal] (10, 2) NULL,
[CY 2024] [decimal] (10, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_dw_safety] ADD CONSTRAINT [acctg_dw_safety_pk] PRIMARY KEY CLUSTERED  ([Release_ID], [Version], [Mnemonic-Vehicle/Plant]) ON [PRIMARY]
GO
