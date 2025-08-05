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

/obj/item/modular_computer/restore_saved_value(attribute, resolved_value)
	//restore saved files
	if(attribute == "stored_files")
		for(var/program_type in resolved_value)
			var/datum/computer_file/program = text2path(program_type)
			program = new program
			if(!store_file(program))
				qdel(program)

		return

	..()

/obj/item/rwd/restore_saved_value(attribute, resolved_value)
	if(attribute == "cable_coil")
		cable = new (src, resolved_value)

		return

	..()

/obj/item/mod/module/storage/restore_saved_value(attribute, resolved_value)
	if(attribute == "contents")
		atom_storage.set_locked(STORAGE_NOT_LOCKED)

		..()

		atom_storage.set_locked(STORAGE_FULLY_LOCKED)

		return

	..()

/obj/item/mod/control/restore_saved_value(attribute, resolved_value)
	if(attribute == "core")
		if(!QDELETED(core))
			core.uninstall()
			qdel(core)

		for(var/obj/item/mod/module/installed in contents)
			uninstall(installed)
			qdel(installed)

		var/obj/item/mod/core/resolved_core = resolved_value
		resolved_core.install(src)

		return

	if(findtext(attribute, "module"))
		install(resolved_value)

		return

	..()

/obj/item/gun/energy/recharge/kinetic_accelerator/restore_saved_value(attribute, resolved_value)
	if(findtext(attribute, "modkit"))
		var/obj/item/borg/upgrade/modkit/mod = resolved_value

		mod.install(src, usr)

		return

	..()

/obj/item/tank/restore_saved_value(attribute, resolved_value)
	if(attribute == "air")
		air_contents.merge(SSair.parse_gas_string(resolved_value))

		return

	..()

/obj/item/card/id/restore_saved_value(attribute, resolved_value)
	if(attribute == "data")
		var/list/data = resolved_value

		registered_account.account_job = SSjob.get_job_type(data[1])
		registered_account.account_balance = data[2]
		registered_account.mining_points = data[3]
		registered_account.bitrunning_points = data[4]

		return

	..()

/obj/item/disk/tech_disk/restore_saved_value(attribute, resolved_value)
	if(attribute == "researched_nodes")
		stored_research.researched_nodes.Cut()

		stored_research.researched_nodes += resolved_value

		return

	if(attribute == "visible_nodes")
		stored_research.visible_nodes.Cut()

		stored_research.visible_nodes += resolved_value

		return

	if(attribute == "available_nodes")
		stored_research.available_nodes.Cut()

		stored_research.available_nodes += resolved_value

		return

	if(attribute == "researched_designs")
		stored_research.researched_designs.Cut()

		stored_research.researched_designs += resolved_value

		return

	if(attribute == "hidden_nodes")
		stored_research.hidden_nodes.Cut()

		stored_research.hidden_nodes += resolved_value

		return

	..()

/obj/item/holosign_creator/restore_saved_value(attribute, resolved_value)
	if(attribute == "signs")
		for(var/text_loc in resolved_value)
			var/list/loc_list = splittext(text_loc, "$")
			for(var/i in 1 to loc_list.len)
				loc_list[i] = text2num(loc_list[i])
			var/obj/structure/holosign/hologram = locate(holosign_type) in TURF_FROM_COORDS_LIST(loc_list)
			hologram.projector = src
			LAZYADD(signs, hologram)

		return

	..()
