/obj/machinery/get_save_vars()
	. = ..()

	//only export parts if there is a circuit board that adds the components
	if(length(component_parts))
		//export datum component parts seperately
		var/list/datum_components = list()
		for(var/datum/stock_part/part in component_parts)
			datum_components += "[part.type]"
		if(datum_components.len)
			. += list(list("datum_components" = datum_components))

	//export everything else
	. += NAMEOF(src, contents)

/obj/machinery/ore_silo/get_save_vars()
	. = ..()

	var/list/material_list = materials.materials
	var/list/material_list_string = list()
	for(var/datum/material/mat in material_list)
		if(!material_list[mat])
			continue
		material_list_string[mat.type] = material_list[mat]
	if(!material_list_string.len)
		return

	. += list(list("materials" = material_list_string))

/obj/machinery/power/smes/get_save_vars()
	. = ..()
	. += NAMEOF(src, input_level)
	. += NAMEOF(src, output_level)
	for(var/obj/item/stock_parts/power_store/cell in component_parts)
		cell.charge = (charge / capacity) * cell.maxcharge

/obj/machinery/power/apc/get_save_vars()
	. = ..()
	if(!auto_name)
		. -= NAMEOF(src, name)
	. += NAMEOF(src, opened)
	. += NAMEOF(src, coverlocked)
	. += NAMEOF(src, lighting)
	. += NAMEOF(src, equipment)
	. += NAMEOF(src, environ)

	. += NAMEOF(src, cell_type)
	if(cell_type)
		start_charge = cell.charge / cell.maxcharge // only used in Initialize() so direct edit is fine
		. += NAMEOF(src, start_charge)

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
