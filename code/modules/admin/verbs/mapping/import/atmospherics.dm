/obj/machinery/atmospherics/pipe/restore_saved_value(attribute, resolved_value)
	if(attribute == "air")
		var/datum/gas_mixture/air_mixture = SSair.parse_gas_string(resolved_value)
		if(parent)
			parent.set_air(air_mixture)
		else
			air_temporary = air_mixture
		return

	..()

/obj/machinery/atmospherics/components/binary/crystallizer/restore_saved_value(attribute, resolved_value)
	if(attribute == "recipe")
		selected_recipe = GLOB.gas_recipe_meta[resolved_value]
		update_parents() //prevent the machine from stopping because of the recipe change and the pipenet not updating
		moles_calculations()

	..()
