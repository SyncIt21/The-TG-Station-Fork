
/obj/get_save_vars()
	. = ..()
	. += NAMEOF(src, req_access)
	. += NAMEOF(src, id_tag)

/obj/effect/decal/cleanable/blood/footprints/get_save_vars()
	. = ..()
	. -= NAMEOF(src, icon_state)

/obj/item/get_save_vars()
	. = ..()
	if(contents.len && atom_storage)
		. += NAMEOF(src, contents)

/obj/item/stack/get_save_vars()
	. = ..()
	. += NAMEOF(src, amount)

/obj/docking_port/get_save_vars()
	. = ..()
	. += NAMEOF(src, dheight)
	. += NAMEOF(src, dwidth)
	. += NAMEOF(src, height)
	. += NAMEOF(src, shuttle_id)
	. += NAMEOF(src, width)

/obj/item/storage/get_save_vars()
	. = ..()
	. += NAMEOF(src, init_storage)

/obj/item/pipe/get_save_vars()
	. = ..()
	. += NAMEOF(src, piping_layer)
	. += NAMEOF(src, pipe_color)

/obj/docking_port/stationary/get_save_vars()
	. = ..()
	. += NAMEOF(src, roundstart_template)

/obj/item/stock_parts/power_store/get_save_vars()
	. = ..()
	. += NAMEOF(src, charge)
	. += NAMEOF(src, rigged)
	return .

/obj/item/photo/get_save_vars()
	. = ..()
	. -= NAMEOF(src, icon)

/obj/item/modular_computer/get_save_vars()
	. = ..()

	//we dont save stuff like the cpu directly as that errors in init
	. -= NAMEOF(src, contents)

	//store power source
	if(!QDELETED(internal_cell))
		. += NAMEOF(src, internal_cell)

	//store all programs that don't load up on default
	var/list/stored_files = list("stored_files" = list())
	for(var/datum/computer_file/program in stored_files)
		if(program.type in starting_programs)
			continue
		stored_files["stored_files"] += "[program.type]"
	if(length(stored_files["stored_files"]))
		. += list(stored_files)
