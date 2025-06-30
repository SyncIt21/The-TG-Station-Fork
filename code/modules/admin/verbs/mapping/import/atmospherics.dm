/obj/machinery/atmospherics/restore_saved_value(attribute, resolved_value)
	if(attribute == "on")
		on = FALSE

		set_on(TRUE)

		return

	..()

/obj/machinery/atmospherics/pipe/restore_saved_value(attribute, resolved_value)
	if(attribute == "air")
		var/datum/gas_mixture/air_mixture = SSair.parse_gas_string(resolved_value)
		if(parent)
			parent.set_air(air_mixture)
		else
			air_temporary = air_mixture
		return

	..()

/obj/machinery/atmospherics/components/restore_saved_value(attribute, resolved_value)
	if(attribute == "airs")
		for(var/gas in resolved_value)
			var/list/gas_data = splittext(gas, "/")
			airs[text2num(gas_data[2])].merge(SSair.parse_gas_string(replacetext(gas_data[1], "%", "=")))

		return

	..()

/obj/machinery/atmospherics/components/binary/crystallizer/restore_saved_value(attribute, resolved_value)
	if(attribute == "recipe")
		selected_recipe = GLOB.gas_recipe_meta[resolved_value]
		update_parents() //prevent the machine from stopping because of the recipe change and the pipenet not updating
		moles_calculations()
		return

	..()

/obj/machinery/atmospherics/components/unary/vent_scrubber/restore_saved_value(attribute, resolved_value)
	if(attribute == "filters")
		filter_types.Cut()
		for(var/gas_type in resolved_value)
			filter_types += gas_type
		atmos_conditions_changed()

		return

	..()

/obj/machinery/computer/atmos_control/restore_saved_value(attribute, resolved_value)
	if(attribute == "sensor_coords")
		var/list/sensor_turfs = list()
		for(var/sensor_id in resolved_value)
			var/list/sensor_coords = splittext(resolved_value[sensor_id], "%")
			for(var/i in 1 to sensor_coords.len)
				sensor_coords[i] = text2num(sensor_coords[i])
			sensor_turfs[sensor_id] = TURF_FROM_COORDS_LIST(sensor_coords)
		if(sensor_turfs.len)
			addtimer(CALLBACK(src, PROC_REF(_connect_sensors), sensor_turfs), 0.1 SECONDS)

		return

	..()

///Connect the sensors only after it has loaded
/obj/machinery/computer/atmos_control/proc/_connect_sensors(list/sensor_turfs)
	PRIVATE_PROC(TRUE)

	connected_sensors = connected_sensors.Copy()
	for(var/sensor_id in sensor_turfs)
		var/obj/machinery/air_sensor/sensor = locate() in sensor_turfs[sensor_id]
		if(!QDELETED(sensor))
			connected_sensors[sensor_id] = sensor.id_tag

/obj/machinery/air_sensor/restore_saved_value(attribute, resolved_value)
	if(attribute == "inlet_coords")
		addtimer(CALLBACK(src, PROC_REF(_connect_valve), TURF_FROM_COORDS_LIST(resolved_value), TRUE), 0.1 SECONDS)

		return

	if(attribute == "outlet_coords")
		addtimer(CALLBACK(src, PROC_REF(_connect_valve), TURF_FROM_COORDS_LIST(resolved_value), FALSE), 0.1 SECONDS)

		return

	..()

///Connects the injector/pump to the air sensor
/obj/machinery/air_sensor/proc/_connect_valve(turf/valve_turf, connect_inlet)
	PRIVATE_PROC(TRUE)

	if(connect_inlet)
		var/obj/machinery/atmospherics/components/unary/outlet_injector/inlet = locate() in valve_turf
		if(!QDELETED(inlet))
			inlet_id = inlet.id_tag
	else
		var/obj/machinery/atmospherics/components/unary/vent_pump/outlet = locate() in valve_turf
		if(!QDELETED(outlet))
			outlet_id = outlet.id_tag
