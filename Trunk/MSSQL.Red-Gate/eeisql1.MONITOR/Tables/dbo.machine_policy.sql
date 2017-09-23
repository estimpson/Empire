CREATE TABLE [dbo].[machine_policy]
(
[machine] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[job_change] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[schedule_queue] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[start_stop_login] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[process_control] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[access_inventory_control] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[material_substitution] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[change_std_pack] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[change_packaging] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[change_unit] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[job_completion_delete] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[material_issue_delete] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[defects_delete] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[downtime_delete] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[smallest_downtime_increment] [int] NOT NULL,
[downtime_histogram_days] [int] NOT NULL,
[work_order_display_window] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[packaging_line] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator_required] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[supervisorclose] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[machine_policy] ADD CONSTRAINT [PK__machine_policy__32E0915F] PRIMARY KEY CLUSTERED  ([machine]) ON [PRIMARY]
GO
