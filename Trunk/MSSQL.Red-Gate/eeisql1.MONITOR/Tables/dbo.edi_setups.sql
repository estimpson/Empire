CREATE TABLE [dbo].[edi_setups]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[supplier_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[trading_partner_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[release_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[auto_create_asn] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[asn_overlay_group] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equipment_description] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pool_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[pool_code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_issuer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id_code_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_model_year] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_po] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_cum_in_asn] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIShipToID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessEDI] [int] NULL,
[TransitDays] [int] NULL,
[EDIOffsetDays] [int] NULL,
[PlanningReleasesFlag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__edi_setup__Plann__02B22128] DEFAULT ('A'),
[ReferenceAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdjustmentAccum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckCustomerPOFirm] [int] NULL,
[PlanningReleaseHorizonDaysBack] [int] NULL,
[ShipScheduleHorizonDaysBack] [int] NULL,
[ProcessShipSchedule] [int] NULL,
[ProcessPlanningRelease] [int] NULL,
[IConnectID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE TRIGGER [dbo].[ftr_edi_setups_i] ON [dbo].[edi_setups] AFTER INSERT
AS
BEGIN

	-- 03/27/2017 Andre Boulanger FT, LLC. Created trigger becuase Empire does not maintain the column EDIOffsetdays in Monitor
	SET NOCOUNT ON;
	-- declarations
	DECLARE	@destination VARCHAR(20),
			@idCodeType VARCHAR(50)

	-- get first updated/inserted row
	SELECT	@destination = MIN(destination)
	FROM	inserted
	-- get id_code_type from inserted row
	SELECT	@idCodeType = MIN(id_code_type)
	FROM	inserted
	WHERE	inserted.destination = @destination

	
	IF ISNUMERIC(@idCodeType) = 1 
	BEGIN

		UPDATE 	edi_setups 
		SET		EDIOffsetDays = @idCodeType
		FROM 	edi_setups
		WHERE	destination = @destination

	END

	UPDATE dbo.edi_setups
	SET auto_create_asn = ''
	WHERE auto_create_asn = 'Y'
	AND destination = @destination

	UPDATE dbo.edi_setups
	SET IConnectID =			CASE  
											WHEN PATINDEX('%:%', trading_partner_code) >= 1 
											THEN SUBSTRING(trading_partner_code,PATINDEX('%:%', trading_partner_code)+1, 20)
											ELSE trading_partner_code
											END
	WHERE destination = @destination
	AND NULLIF(IConnectID,'') IS NULL

END


GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE TRIGGER [dbo].[ftr_edi_setups_u] ON [dbo].[edi_setups] AFTER UPDATE
AS
BEGIN

	-- 03/27/2017 Andre Boulanger FT, LLC. Created trigger becuase Empire does not maintain the column EDIOffsetdays in Monitor
	-- 03/22/2019 Andre Boulanger FT, LLC . Updated so that Empire users have full control over their edi_setups.
	SET NOCOUNT ON;
	-- declarations
	DECLARE	@destination VARCHAR(20),
			@idCodeType VARCHAR(50)

	-- get first updated/inserted row
	SELECT	@destination = MIN(destination)
	FROM	inserted
	-- get id_code_type from inserted row
	SELECT	@idCodeType = MIN(inserted.id_code_type)
	FROM	inserted
	JOIN	deleted ON deleted.destination = inserted.destination
	WHERE	inserted.destination = @destination 


	
	IF ISNUMERIC(@idCodeType) = 1 
	BEGIN

		UPDATE 	es 
		SET		es.EDIOffsetDays = @idCodeType
		FROM 	edi_setups es
		JOIN 	inserted i ON i.destination = es.destination
	    JOIN		deleted D ON D.destination = I.destination
		WHERE	ES.destination = @destination
		AND			COALESCE(d.id_code_type,'A') != COALESCE(i.id_code_type,'B')

	END

	/*UPDATE es
	SET es.auto_create_asn = '',
			IConnectID =			CASE  
											WHEN PATINDEX('%:%', i.trading_partner_code) >= 1 
											THEN SUBSTRING(i.trading_partner_code,PATINDEX('%:%', i.trading_partner_code)+1, 20)
											ELSE i.trading_partner_code
											END
	FROM 	edi_setups es
		JOIN 	inserted i ON i.destination = es.destination
	    JOIN		deleted D ON D.destination = I.destination
	WHERE i.auto_create_asn = 'Y' AND
				 ISNUMERIC(NULLIF((CASE  
											WHEN PATINDEX('%:%', i.trading_partner_code) >= 1 
											THEN SUBSTRING(i.trading_partner_code,PATINDEX('%:%', i.trading_partner_code)+1, 20)
											ELSE i.trading_partner_code
											END),'')) = 1				

	*/

END


GO
ALTER TABLE [dbo].[edi_setups] ADD CONSTRAINT [PK__edi_setups__1C323631] PRIMARY KEY CLUSTERED  ([destination]) ON [PRIMARY]
GO
