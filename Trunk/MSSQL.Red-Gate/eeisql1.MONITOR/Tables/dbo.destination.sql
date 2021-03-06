CREATE TABLE [dbo].[destination]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag] [int] NULL,
[salestax_flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salestax_rate] [numeric] (7, 4) NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_segment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_4] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_5] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_6] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[default_currency_unit] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[show_euro_amount] [smallint] NULL,
[cs_status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[region_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom4] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom5] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom6] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom7] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom8] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom9] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom10] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] AS (case  when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%AUSTRIA%' then 'AUSTRIA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%Mexico%' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%CANADA%' then 'CANADA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%CZECH%' then 'CZECH REPUBLIC' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%CHINA%' then 'CHINA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%FRANCE%' then 'FRANCE' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%GERMANY%' then 'GERMANY' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%KOREA%' then 'KOREA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%Mexico%' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%Netherlands%' then 'NETHERLANDS' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%MEXICO%' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '% MX' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%PORTUGAL%' then 'PORTUGAL' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%SPAIN%' then 'SPAIN' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%TAIWAN%' then 'TAIWAN R.O.C.' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%UNITED KINGDOM%' then 'UNITED KINGDOM' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '% UK' then 'UNITED KINGDOM' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '% UK %' then 'UNITED KINGDOM' when isnull([address_4],'') like '%, __ %[0-9]%' then substring(isnull([address_4],''),patindex('%, __ %[0-9]%',isnull([address_4],''))+(2),(2)) when isnull([address_3],'') like '%, __ %[0-9]%' then substring(isnull([address_3],''),patindex('%, __ %[0-9]%',isnull([address_3],''))+(2),(2)) when isnull([address_3],'') like '%, __. %[0-9]%' then upper(substring(isnull([address_3],''),patindex('%, __. %[0-9]%',isnull([address_3],''))+(2),(2))) when isnull([address_2],'') like '%, __ %[0-9]%' then substring(isnull([address_2],''),patindex('%, __ %[0-9]%',isnull([address_2],''))+(2),(2)) when isnull([address_2],'') like '% __-%[0-9]%' then substring(isnull([address_2],''),patindex('% __-%[0-9]%',isnull([address_2],''))+(1),(2)) when isnull([address_2],'') like '%, __. %[0-9]%' then upper(substring(isnull([address_2],''),patindex('%, __. %[0-9]%',isnull([address_2],''))+(2),(2))) when isnull([address_2],'') like '%, __, %[0-9]%' then upper(substring(isnull([address_2],''),patindex('%, __, %[0-9]%',isnull([address_2],''))+(2),(2))) else 'N/A' end),
[Country] AS (case  when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%AUSTRIA%' then 'AUSTRIA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%Mexico%' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%CANADA%' then 'CANADA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%CZECH%' then 'CZECH REPUBLIC' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%CHINA%' then 'CHINA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%FRANCE%' then 'FRANCE' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%GERMANY%' then 'GERMANY' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%KOREA%' then 'KOREA' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%Mexico%' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%Netherlands%' then 'NETHERLANDS' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%MEXICO%' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '% MX' then 'MEXICO' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%PORTUGAL%' then 'PORTUGAL' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%SPAIN%' then 'SPAIN' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%TAIWAN%' then 'TAIWAN R.O.C.' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '%UNITED KINGDOM%' then 'UNITED KINGDOM' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '% UK' then 'UNITED KINGDOM' when ((isnull([address_2],'')+isnull([address_3],''))+isnull([address_4],''))+isnull([address_5],'') like '% UK %' then 'UNITED KINGDOM' when isnull([address_4],'') like '%, __ %[0-9]%' then 'UNITED STATES OF AMERICA' when isnull([address_3],'') like '%, __ %[0-9]%' then 'UNITED STATES OF AMERICA' when isnull([address_3],'') like '%, __. %[0-9]%' then 'UNITED STATES OF AMERICA' when isnull([address_2],'') like '%, __ %[0-9]%' then 'UNITED STATES OF AMERICA' when isnull([address_2],'') like '% __-%[0-9]%' then 'UNITED STATES OF AMERICA' when isnull([address_2],'') like '%, __. %[0-9]%' then 'UNITED STATES OF AMERICA' when isnull([address_2],'') like '%, __, %[0-9]%' then 'UNITED STATES OF AMERICA' else 'N/A' end),
[Regdt] [datetime] NOT NULL CONSTRAINT [DF_destination_Regdt] DEFAULT (getdate()),
[Regby] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdateDT] [datetime] NULL,
[LastUpdateBy] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[contact_email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[position] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[portal_link] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[portal_link_user] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[portal_link_pass] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[consigned] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_destination_consigned] DEFAULT ('N'),
[primaryLocation_consigned] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[secondaryLocation_consigned] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create trigger [dbo].[mtr_destination_u] on [dbo].[destination] for update
as
begin
	-- declarations
	declare @destination varchar(20),
			@cs_status varchar(20),
			@deleted_status varchar(20)

	-- get first updated row
	select	@destination = min(destination)
	from 	inserted

	-- loop through all updated records and if cs_status has been modified, update 
	-- orders with new status
	while(isnull(@destination,'-1') <> '-1')
	begin

		select	@cs_status = cs_status
		from	inserted
		where	destination = @destination

		select	@deleted_status = cs_status
		from	deleted
		where	destination = @destination

		select @cs_status = isnull(@cs_status,'')
		select @deleted_status = isnull(@deleted_status,'')

		if @cs_status <> @deleted_status
			update 	order_header
			set		cs_status = @cs_status
			where 	destination = @destination

		select	@destination = min(destination)
		from 	inserted
		where	destination > @destination

	end
end


GO
ALTER TABLE [dbo].[destination] ADD CONSTRAINT [PK__destination__25E688F4] PRIMARY KEY CLUSTERED  ([destination]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[destination] TO [APPUser]
GO
