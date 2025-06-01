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
		for(var/obj/part in component_parts)
			component_parts -= part
			qdel(part)

		//add new parts
		for(var/obj/item in resolved_value)
			component_parts += item
			item.forceMove(src)
			if(istype(item, /obj/item/circuitboard))
				circuit = item

		//refresh parts to update the machine
		if(circuit)
			RefreshParts()

/obj/machinery/ore_silo/restore_saved_value(attribute, resolved_value)
	if(attribute == "materials")
		for(var/material_id in resolved_value)
			materials.insert_amount_mat(resolved_value[material_id], text2path(material_id))
		return

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
