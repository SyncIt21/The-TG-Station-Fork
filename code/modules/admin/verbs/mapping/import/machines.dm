/obj/machinery/restore_saved_value(attribute, resolved_value)
	var/static/should_refresh = FALSE
	if(attribute == "datum_components")
		//remove existing parts
		for(var/datum/stock_part/part in component_parts)
			component_parts -= part

		//add new parts
		for(var/part_path in resolved_value)
			component_parts += GLOB.stock_part_datums[text2path(part_path)]

		should_refresh = TRUE

	else if(attribute == "contents")
		var/list/contents = resolved_value
		var/list/req_components = null

		//remove default parts
		circuit = null
		for(var/atom/part in component_parts)
			component_parts -= part
			qdel(part)

		//locate circuit board & filter required components if applicable
		var/obj/item/circuitboard/board = locate() in contents
		if(!QDELETED(board))
			circuit = board
			circuit.forceMove(src)
			contents -= circuit
			component_parts += circuit
			if(istype(board, /obj/item/circuitboard/machine))
				var/obj/item/circuitboard/machine/mech = circuit
				req_components = mech.req_components.Copy()

		//other stuff which can also be part of component_parts should be filtered out
		for(var/atom/movable/thing in contents)
			thing.forceMove(src)

			for(var/part_type in req_components)
				if(istype(thing, part_type))
					//append the part
					component_parts += thing

					//keep track of how much more are required
					var/count = req_components[part_type] - 1
					if(!count)
						req_components -= part_type
						continue
					req_components[part_type] = count

					//time to refresh
					should_refresh = TRUE

		//time to refresh
		if(should_refresh)
			RefreshParts()
			should_refresh = FALSE

/obj/machinery/ore_silo/restore_saved_value(attribute, resolved_value)
	if(attribute == "materials")
		for(var/material_id in resolved_value)
			materials.insert_amount_mat(resolved_value[material_id], text2path(material_id))
		return

	..()

/obj/machinery/space_heater/restore_saved_value(attribute, resolved_value)
	if(attribute == "contents")
		//restore cell from contents
		cell = locate(/obj/item/stock_parts/power_store) in resolved_value

		return ..()

	..()

/obj/machinery/electrolyzer/restore_saved_value(attribute, resolved_value)
	..()

	if(attribute == "contents")
		cell = locate() in resolved_value
