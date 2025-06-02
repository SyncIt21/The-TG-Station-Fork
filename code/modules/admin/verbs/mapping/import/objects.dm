/obj/machinery/restore_saved_value(attribute, resolved_value)
	if(attribute == "datum_components")
		//remove existing parts
		for(var/datum/stock_part/part in component_parts)
			component_parts -= part

		//add new parts
		for(var/part_path in resolved_value)
			component_parts += GLOB.stock_part_datums[text2path(part_path)]

	else if(attribute == "contents")
		//remove existing parts
		for(var/obj/item/part in component_parts)
			component_parts -= part
			qdel(part)

		//locate circuit board
		circuit = locate() in resolved_value
		circuit.forceMove(src)
		component_parts += circuit

		//add new parts
		var/obj/item/circuitboard/machine/mech = circuit
		if(istype(mech))
			var/list/req_components = mech.req_components.Copy()
			for(var/obj/item/part in resolved_value)
				part.forceMove(src)
				for(var/part_type in req_components)
					if(istype(part, part_type))
						//append the part
						component_parts += part

						//keep track of how much more are required
						var/count = req_components[part_type] - 1
						if(!count)
							req_components -= part_type
							continue
						req_components[part_type] = count

		//refresh parts to update the machine
		if(circuit)
			RefreshParts()

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

/obj/structure/closet/restore_saved_value(attribute, resolved_value)
	//the maploader flattens reccursive contents out on the turf(e.g. like a backpack having stuff but its inside the closet)
	//but closets on init takes everything on the turf even stuff that does not belong to it
	//so we move out stuff that isnt ours
	if(attribute == "contents")
		var/atom/drop = drop_location()
		for(var/obj/thing in contents)
			if(!(thing in resolved_value))
				thing.forceMove(drop)

		return

	..()
