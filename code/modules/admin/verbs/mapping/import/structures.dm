/obj/structure/frame/machine/restore_saved_value(attribute, resolved_value)
	if(attribute == "contents")
		..()

		for(var/obj/item/part as anything in contents)
			if(istype(part, /obj/item/circuitboard/machine))
				var/list/added_components = req_components.Copy()
				circuit = part
				circuit_added(part)
				req_components = added_components
			else
				LAZYADD(part, components)

		return

	..()

/obj/structure/frame/computer/restore_saved_value(attribute, resolved_value)
	if(attribute == "board")
		circuit = resolved_value
		circuit.forceMove(src)
		circuit_added(resolved_value)

		return

	..()
