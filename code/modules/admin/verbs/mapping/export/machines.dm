/obj/machinery/get_save_vars()
	. = ..()

	if(length(component_parts))
		//export datum component parts seperately
		var/list/datum_components = list()
		for(var/datum/stock_part/part in component_parts)
			datum_components += part.type
		//if we have an atom part defer refreshing parts
		if(!(locate(/atom/movable) in (component_parts - circuit)))
			datum_components += "refresh"
		//save as custom var
		if(datum_components.len)
			. += list(list("datum_components" = datum_components))

	//export everything else
	. += NAMEOF(src, contents)

/obj/machinery/ore_silo/get_save_vars()
	. = ..()

	. += list(list("materials" = SSmaterials.to_list(materials)))

/obj/machinery/chem_master/get_save_vars()
	. = ..()

	. += NAMEOF(src, beaker)

/obj/machinery/chem_heater/get_save_vars()
	. = ..()

	. += NAMEOF(src, target_temperature)
	. += NAMEOF(src, heater_coefficient)
	. += NAMEOF(src, on)
	. += NAMEOF(src, dispense_volume)
	. += NAMEOF(src, beaker)

/obj/machinery/autolathe/get_save_vars()
	. = ..()

	. += list(list("local_container" = SSmaterials.to_list(materials)))

/obj/machinery/rnd/production/get_save_vars()
	. = ..()

	if(QDELETED(materials.silo))
		. += list(list("local_container" = SSmaterials.to_list(materials.mat_container)))

/obj/machinery/mecha_part_fabricator/get_save_vars()
	. = ..()

	if(QDELETED(rmat.silo))
		. += list(list("local_container" = SSmaterials.to_list(rmat.mat_container)))

/obj/machinery/component_printer/get_save_vars()
	. = ..()

	if(QDELETED(materials.silo))
		. += list(list("local_container" = SSmaterials.to_list(materials.mat_container)))

/obj/machinery/bouldertech/get_save_vars()
	. = ..()

	if(QDELETED(silo_materials.silo))
		. += list(list("local_container" = SSmaterials.to_list(silo_materials.mat_container)))

/obj/machinery/mineral/ore_redemption/get_save_vars()
	. = ..()

	if(QDELETED(materials.silo))
		. += list(list("local_container" = SSmaterials.to_list(materials.mat_container)))

/obj/machinery/power/smes/get_save_vars()
	. = ..()
	. += NAMEOF(src, charge)
	. += NAMEOF(src, input_level)
	. += NAMEOF(src, output_level)

/obj/machinery/power/apc/get_save_vars()
	. = ..()
	if(!auto_name)
		. -= NAMEOF(src, name)
	. += NAMEOF(src, opened)
	. += NAMEOF(src, coverlocked)
	. += NAMEOF(src, lighting)
	. += NAMEOF(src, equipment)
	. += NAMEOF(src, environ)

	if(!QDELETED(cell))
		. += NAMEOF(src, cell)
	// TODO save the wire data but need to include states for cute wires, signalers attached to wires, etc.

/obj/machinery/airalarm/get_save_vars()
	. = ..()
	. -= NAMEOF(src, name)

/obj/machinery/door/poddoor/get_save_vars()
	. = ..()
	. += NAMEOF(src, id)

/obj/machinery/door/password/get_save_vars()
	. = ..()
	. += NAMEOF(src, password)

/obj/machinery/door/get_save_vars()
	. = ..()
	. += NAMEOF(src, welded)

/obj/machinery/door/airlock/get_save_vars()
	. = ..()
	. -= NAMEOF(src, icon_state) // airlocks ignore icon_state and instead use get_airlock_overlay()
	// TODO save the wire data but need to include states for cute wires, signalers attached to wires, etc.

/obj/machinery/button/get_save_vars()
	. = ..()
	. += NAMEOF(src, id)

/obj/machinery/modular_computer/get_save_vars()
	. = ..()

	//so we dont save the internal cpu and stuff
	. -= NAMEOF(src, contents)

	//to save starting programs of the cpu
	var/list/stored_files = list("stored_files" = list())
	for(var/datum/computer_file/file in cpu.stored_files)
		if(file.type in cpu.starting_programs)
			continue
		stored_files["stored_files"] += "[file.type]"
	if(length(stored_files["stored_files"]))
		. += list(stored_files)

/obj/machinery/power/emitter/get_save_vars()
	. = ..()
	. += NAMEOF(src, active)
	. += NAMEOF(src, welded)
	. += NAMEOF(src, locked)

/obj/machinery/power/supermatter_crystal/get_save_vars()
	. = ..()
	if(absorbed_gasmix)
		. += list(list("absorbed_gases" = absorbed_gasmix.to_string()))
	. += NAMEOF(src, internal_energy)
	. += NAMEOF(src, damage)

/obj/machinery/door/poddoor/get_save_vars()
	. = ..()
	. += NAMEOF(src, deconstruction)
	. += NAMEOF(src, id)

/obj/machinery/button/get_save_vars()
	. = ..()
	. += NAMEOF(src, id)

	if(!QDELETED(device))
		. += NAMEOF(src, device)

	if(!QDELETED(board))
		. += NAMEOF(src, board)

/obj/machinery/airalarm/get_save_vars()
	. = ..()

	. += NAMEOF(src, allow_link_change)
	if(length(air_sensor_chamber_id))
		. += list(list("air_sensor" = air_sensor_chamber_id))

/obj/machinery/air_sensor/get_save_vars()
	. = ..()
	. += NAMEOF(src, id_tag)
