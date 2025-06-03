/obj/machinery/portable_atmospherics/get_save_vars()
	. = ..()
	var/datum/gas_mixture/gasmix = return_air()
	if(gasmix)
		initial_gas_mix = gasmix.to_string()
		. += NAMEOF(src, initial_gas_mix)

/obj/machinery/portable_atmospherics/canister/get_save_vars()
	. = ..()
	. += NAMEOF(src, valve_open)
	. += NAMEOF(src, release_pressure)

/obj/machinery/atmospherics/get_save_vars()
	. = ..()
	. += NAMEOF(src, piping_layer)
	. += NAMEOF(src, pipe_color)
	. -= NAMEOF(src, contents)

/obj/machinery/atmospherics/pipe/get_save_vars()
	. = ..()

	if(parent && !parent.saved)
		. += list(list("air" = parent.air.to_string()))
		parent.saved = TRUE
		return

	if(air_temporary)
		. += list(list("air" = air_temporary.to_string()))

/obj/machinery/atmospherics/components/get_save_vars()
	. = ..()
	if(!override_naming)
		// Prevents saving the dynamic name with \proper due to it converting to "???"
		. -= NAMEOF(src, name)
	. += NAMEOF(src, welded)
