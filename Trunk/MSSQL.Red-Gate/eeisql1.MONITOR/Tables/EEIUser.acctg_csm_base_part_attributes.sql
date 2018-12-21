CREATE TABLE [EEIUser].[acctg_csm_base_part_attributes]
(
[release_id] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[base_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[family] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_line] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_market_segment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_market_subsegment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_application] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_sop] [smalldatetime] NULL,
[empire_eop] [smalldatetime] NULL,
[include_in_forecast] [bit] NOT NULL CONSTRAINT [DF__acctg_csm__inclu__19AA9948] DEFAULT ((0)),
[Salesperson] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_of_award] [date] NULL,
[type_of_award] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mid_model_year] [datetime] NULL,
[empire_eop_note] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[verified_eop] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[verified_eop_date] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_base_part_attributes] ADD CONSTRAINT [PK_acctg_csm_base_part_attributes2] PRIMARY KEY CLUSTERED  ([release_id], [base_part]) ON [PRIMARY]
GO
