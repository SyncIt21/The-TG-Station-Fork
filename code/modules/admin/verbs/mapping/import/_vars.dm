
/**
 * Restore an variable of this atom from a map file which can be either an
 * 1) obj atom
 * 2) custom variable(begins with $)
 * Arguments
 *
 * * attribute - the attribute name
 * * resolved_value - the resolved atom/list of atoms
 */
/atom/proc/restore_saved_value(attribute, resolved_value)
	SHOULD_CALL_PARENT(TRUE)

	if(attribute == "reagents")
		var/list/reagent_list = resolved_value

		create_reagents(text2num(popkey(reagent_list, "max_volume")), text2num(popkey(reagent_list, "flags")))
		var/temp = text2num(popkey(reagent_list, "temp"))
		for(var/reg_path in reagent_list)
			var/list/reg_data = splittext(reagent_list[reg_path], "/")
			reagents.add_reagent(
				reg_path,
				text2num(reg_data[1]),
				reagtemp = temp,
				added_purity = text2num(reg_data[2]),
				added_ph = text2num(reg_data[3])
			)

/atom/movable/restore_saved_value(attribute, resolved_value)
	if(attribute == "contents")
		for(var/obj/item in contents)
			qdel(item)

		for(var/obj/item in resolved_value)
			if(atom_storage)
				atom_storage.attempt_insert(item, override = TRUE, messages = FALSE)
			else
				item.forceMove(src)

		return

	var/atom/data = resolved_value
	if(isatom(data))
		var/value = vars[attribute]
		if(isatom(value)) //it may contain an default value which we want to delete
			qdel(value)
		vars[attribute] = data
		if(ismovable(data))
			var/atom/movable/move = data
			move.forceMove(src)
		return

	..()

/turf/open/restore_saved_value(attribute, resolved_value)
	if(attribute == "pipe_display")
		for(var/obj/machinery/atmospherics/pipe/thing in contents)
			SEND_SIGNAL(thing, COMSIG_OBJ_HIDE, UNDERFLOOR_INTERACTABLE)

		return

	..()
