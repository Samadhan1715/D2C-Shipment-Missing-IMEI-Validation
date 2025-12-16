
---------------------QA Query 2 -----------------------------




				drop table if exists #table_auction_details_stage_step1

		select * into #table_auction_details_stage_step1
		from  [10.0.4.251].att_rlo.dbo.table_auction_details_stage  with(nolock)
		where created_date  >= '2025-04-01' and 
		      created_date  <= '2025-06-30'

		---cast(created_date as date) =@maxcreated_date_details_stage
		and left(lot_number,3) = 'D2C'


						CREATE INDEX IX1 ON #table_auction_details_stage_step1 (serial_number, sales_order);



		drop table if exists #table_rl1_daily_invoice_d2c_data_step1

		SELECT A.transaction_id,A.staging_table_id,A.delivery_id,A.delivery_detail_id,A.order_number,A.line_number,A.source_line_number,A.customer_number
		,A.inventory_item_id,A.organization_code,A.requested_qty,A.uom,A.shipped_qty,B.lot_number,B.cosmetic_grade,
		A.serial_number,A.to_serial_number,A.ship_method_code
		,A.carrier_id,A.fob_code,A.org_id,A.tracking_number,A.currency_code,A.error_description,A.processed_flag,A.acknowledgement_flag,A.error_code,A.error_line_number
		,A.shipment_priority_code,A.segment1,A.segment3,A.created_by,A.creation_date,A.last_updated_by,A.last_update_date,A.freight_carrier_code,A.ind_serial_num_flag
		,A.attribute1,A.attribute2,A.attribute3,A.attribute4,A.attribute5,A.attribute6,A.attribute7,A.attribute8,A.attribute9,A.attribute10,A.mac_address,A.cross_reference
		,A.attribute11 ,A.attribute12 ,A.attribute13 ,A.attribute14 ,A.attribute15 ,A.related_serial_number ,A.iccid_number ,A.interface_to_lens ,A.dl_parent_id ,A.dl_bundle_code 
		,A.common_order_num ,A.common_receipt_num ,A.uc_p65_prtflg ,A.insertdate ,A.process_status ,A.flag_1 ,A.flag_2 ,A.flag_3 ,A.flag_4 ,A.source_org_code 
		,A.request_date_fileoffset_adjusted_datetime ,A.request_date_dcoffset_adjusted_datetime ,A.date_shipped_fileoffset_adjusted_datetime 
		,A.date_shipped_dcoffset_adjusted_datetime ,A.atc_creation_date_fileoffset_adjusted_datetime ,A.atc_creation_date_dcoffset_adjusted_datetime ,A.message_id 
		,A.stage_insert_date ,A.file_received_date
		into #table_rl1_daily_invoice_d2c_data_step1
		from  [10.0.4.251].att_rlo.dbo.table_atc_delivery_dtl_iface A with(nolock)
		inner join  #table_auction_details_stage_step1 B  with(nolock)
		on A.serial_number = B.serial_number and A.order_number = B.sales_order 

		
				CREATE INDEX IX2 ON #table_rl1_daily_invoice_d2c_data_step1(order_number, lot_number, segment3, cosmetic_grade);

		SELECT A.transaction_id,A.staging_table_id,A.delivery_id,A.delivery_detail_id,A.order_number,A.line_number,A.source_line_number,A.customer_number
		,A.inventory_item_id,A.organization_code,A.requested_qty,A.uom,A.shipped_qty,A.lot_number,A.serial_number,A.to_serial_number,A.ship_method_code
		,A.carrier_id,A.fob_code,A.org_id,A.tracking_number,A.currency_code,A.error_description,A.processed_flag,A.acknowledgement_flag,A.error_code,A.error_line_number
		,A.shipment_priority_code,A.segment1,A.segment3,A.created_by,A.creation_date,A.last_updated_by,A.last_update_date,A.freight_carrier_code,A.ind_serial_num_flag
		,A.attribute1,A.attribute2,A.attribute3,A.attribute4,A.attribute5,A.attribute6,A.attribute7,A.attribute8,A.attribute9,A.attribute10,A.mac_address,A.cross_reference
		,A.attribute11 ,A.attribute12 ,A.attribute13 ,A.attribute14 ,A.attribute15 ,A.related_serial_number ,A.iccid_number ,A.interface_to_lens ,A.dl_parent_id ,A.dl_bundle_code 
		,A.common_order_num ,A.common_receipt_num ,A.uc_p65_prtflg ,A.insertdate ,A.process_status ,A.flag_1 ,A.flag_2 ,A.flag_3 ,A.flag_4 ,A.source_org_code 
		,A.request_date_fileoffset_adjusted_datetime ,A.request_date_dcoffset_adjusted_datetime ,A.date_shipped_fileoffset_adjusted_datetime 
		,A.date_shipped_dcoffset_adjusted_datetime ,A.atc_creation_date_fileoffset_adjusted_datetime ,A.atc_creation_date_dcoffset_adjusted_datetime ,A.message_id 
		,A.stage_insert_date ,A.file_received_date,B.unit_price  as revenue
		--, @actual_file_name as [file_name],
		--@load_id as load_id, 0 as send_alert
		from #table_rl1_daily_invoice_d2c_data_step1 A
		inner join [10.0.4.251].fact_auction_revenue_forecast B with (nolock)
		ON A.order_number = B.oms_order_number and A.lot_number = B.oms_lot_number
		AND A.segment3  =  B.itemsku and A.cosmetic_grade = B.attribute5

