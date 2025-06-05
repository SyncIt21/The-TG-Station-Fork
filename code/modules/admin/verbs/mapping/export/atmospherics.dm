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
	if(on)
		. += NAMEOF(src, on)

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


/obj/machinery/atmospherics/components/unary/thermomachine/get_save_vars()
	. = ..()
	. += NAMEOF(src, target_temperature)

/obj/machinery/atmospherics/components/binary/crystallizer/get_save_vars()
	. = ..()
	if(selected_recipe)
		. += list(list("recipe" = selected_recipe.id))
	. += NAMEOF(src, gas_input)

/obj/machinery/atmospherics/components/trinary/mixer/get_save_vars()
	. = ..()
	. += NAMEOF(src, target_pressure)
	. += NAMEOF(src, node1_concentration)
	. += NAMEOF(src, node2_concentration)

/obj/machinery/atmospherics/components/binary/pump/get_save_vars()
	. = ..()
	. += NAMEOF(src, target_pressure)

/obj/machinery/atmospherics/components/unary/outlet_injector/get_save_vars()
	. = ..()
	. += NAMEOF(src, volume_rate)

/obj/machinery/atmospherics/components/unary/vent_pump/get_save_vars()
	. = ..()
	. += NAMEOF(src, external_pressure_bound)
	. += NAMEOF(src, internal_pressure_bound)
	. += NAMEOF(src, fan_overclocked)

/obj/machinery/atmospherics/components/binary/passive_gate/get_save_vars()
	. = ..()
	. += NAMEOF(src, target_pressure)

/obj/machinery/atmospherics/components/binary/pressure_valve/get_save_vars()
	. = ..()
	. += NAMEOF(src, target_pressure)

/obj/machinery/atmospherics/components/binary/temperature_gate/get_save_vars()
	. = ..()
	. += NAMEOF(src, target_temperature)
	. += NAMEOF(src, inverted)

/obj/machinery/atmospherics/components/binary/volume_pump/get_save_vars()
	. = ..()
	. += NAMEOF(src, transfer_rate)
	. += NAMEOF(src, overclocked)

/obj/machinery/atmospherics/components/binary/temperature_pump/get_save_vars()
	. = ..()
	. += NAMEOF(src, heat_transfer_rate)

/obj/machinery/atmospherics/components/trinary/mixer/get_save_vars()
	. = ..()
	. += NAMEOF(src, target_pressure)
	. += NAMEOF(src, node1_concentration)
	. += NAMEOF(src, node2_concentration)
