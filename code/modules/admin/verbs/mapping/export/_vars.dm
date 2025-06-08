/**
 * Retuns a list of vars that are to be saved during map export
 * You can save object vars as well but they have to restored in /atom/restore_saved_value()
 * Custom variables can also be sent in the format list(name = value) which also have to restored in /atom/restore_saved_value()
 */
/atom/proc/get_save_vars()
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	. += NAMEOF(src, color)
	. += NAMEOF(src, dir)
	. += NAMEOF(src, icon)
	. += NAMEOF(src, icon_state)
	. += NAMEOF(src, name)
	. += NAMEOF(src, pixel_x)
	. += NAMEOF(src, pixel_y)
	. += NAMEOF(src, density)
	. += NAMEOF(src, opacity)

	if(uses_integrity)
		if(atom_integrity != max_integrity) // Only save if atom_integrity differs from max_integrity to avoid redundant saving
			. += NAMEOF(src, atom_integrity)
		. += NAMEOF(src, max_integrity)
		. += NAMEOF(src, integrity_failure)
		. += NAMEOF(src, damage_deflection)
		. += NAMEOF(src, resistance_flags)

	if(!QDELETED(reagents))
		var/list/reagent_list = list(
			"max_volume" = reagents.maximum_volume,
			"flags" =  reagents.flags,
			"temp" = reagents.chem_temp
		)
		for(var/datum/reagent/reg as anything in reagents.reagent_list)
			reagent_list[reg.type] = "[reg.volume]/[reg.ph]/[reg.purity]"
		. += list(list("reagents" = reagent_list))

/atom/movable/get_save_vars()
	. = ..()
	. += NAMEOF(src, anchored)

/turf/open/get_save_vars()
	. = ..()
	var/datum/gas_mixture/turf_gasmix = return_air()
	initial_gas_mix = turf_gasmix.to_string()
	. += NAMEOF(src, initial_gas_mix)

	for(var/obj/machinery/atmospherics/pipe/thing in contents)
		if(!(thing.flags_1 & MAPLOADED_1) && !HAS_TRAIT(thing, TRAIT_UNDERFLOOR))
			. += list(list("pipe_display" = TRUE))
			return

/mob/living/basic/dark_wizard/get_save_vars()
	. = ..()
	. -= NAMEOF(src, icon_state)
