/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Cigarette Box
 *		Cigar Case
 *		Heart Shaped Box w/ Chocolates
 *		Ring Box
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	desc = "Mmm. Donuts."
	resistance_flags = FLAMMABLE
	var/icon_type = "donut"
	var/spawn_type = null
	var/fancy_open = FALSE

/obj/item/storage/fancy/PopulateContents()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	for(var/i = 1 to STR.max_items)
		new spawn_type(src)

/obj/item/storage/fancy/update_icon_state()
	if(fancy_open)
		icon_state = "[icon_type]box[contents.len]"
	else
		icon_state = "[icon_type]box"

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(fancy_open)
		if(length(contents) == 1)
			. += "There is one [icon_type] left."
		else
			. += "There are [contents.len || "no"] [icon_type]s left."

/obj/item/storage/fancy/attack_self(mob/user)
	fancy_open = !fancy_open
	update_icon()
	. = ..()

/obj/item/storage/fancy/Exited()
	. = ..()
	fancy_open = TRUE
	update_icon()

/obj/item/storage/fancy/Entered()
	. = ..()
	fancy_open = TRUE
	update_icon()

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox6"
	icon_type = "donut"
	name = "donut box"
	spawn_type = /obj/item/reagent_containers/food/snacks/donut
	fancy_open = TRUE
	custom_price = PRICE_NORMAL

/obj/item/storage/fancy/donut_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/donut))

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	item_state = "eggbox"
	icon_state = "eggbox"
	icon_type = "egg"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	name = "egg box"
	desc = "A carton for containing eggs."
	spawn_type = /obj/item/reagent_containers/food/snacks/egg

/obj/item/storage/fancy/egg_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 12
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/egg))

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/candle
	fancy_open = TRUE

/obj/item/storage/fancy/candle_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5

/obj/item/storage/fancy/candle_box/attack_self(mob_user)
	return

//fonky shotgun bullet

/obj/item/storage/fancy/ammobox
	name = "box of rubber shots"
	desc = "A box full of rubber shots, designed for riot shotguns."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "bbox"
	w_class = WEIGHT_CLASS_SMALL
	icon_type = "b"
	spawn_type = /obj/item/ammo_casing/shotgun/rubbershot
	var/foldable = /obj/item/stack/sheet/cardboard

/obj/item/storage/fancy/ammobox/attack_self(mob/user)
	. = ..()

	if(!foldable)
		return
	if(contents.len)
		to_chat(user, SPAN_WARNING("You can't fold this box with items still inside!"))
		return
	if(!ispath(foldable))
		return

	to_chat(user, SPAN_NOTICE("You fold [src] flat."))
	var/obj/item/I = new foldable
	qdel(src)
	user.put_in_hands(I)

/obj/item/storage/fancy/ammobox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 14
	STR.can_hold = typecacheof(list(spawn_type))

/obj/item/storage/fancy/ammobox/AltClick(mob/living/carbon/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, SPAN_WARNING("Your hands are full!"))
		return
	var/obj/item/L = locate(spawn_type) in contents
	if(L)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, L, user)
		user.put_in_hands(L)
		to_chat(user, SPAN_NOTICE("You take \a [L] out of the box."))
		return TRUE
	else
		to_chat(user, SPAN_NOTICE("There is nothing left in the box."))
	return TRUE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/storage/fancy/ammobox/beanbag
	name = "box of beanbag slugs"
	desc = "A box full of beanbag slugs, designed for riot shotguns."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "stunbox"
	icon_type = "stun"
	spawn_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/storage/fancy/ammobox/lethalshot
	name = "box of buckshot shotgun shots"
	desc = "A box full of lethal buckshot rounds, designed for riot shotguns."
	icon_state = "gbox"
	icon_type = "g"
	spawn_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/storage/fancy/ammobox/magnumshot
	name = "box of magnum buckshot shotgun shots"
	desc = "A box full of lethal magnum buckshot rounds, designed for hunting shotguns."
	icon_state = "gbox"
	icon_type = "g"
	spawn_type = /obj/item/ammo_casing/shotgun/magnumshot

/obj/item/storage/fancy/ammobox/slugshot
	name = "box of slug shotgun shots"
	desc = "A box full of slug rounds, designed for riot shotguns."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "lbox"
	icon_type = "l"
	spawn_type = /obj/item/ammo_casing/shotgun

/obj/item/storage/fancy/ammobox/beanbag
	name = "box of beanbags"
	desc = "A box full of beanbag shells."
	icon_state = "stunbox"
	icon_type = "stun"
	spawn_type = /obj/item/ammo_casing/shotgun/beanbag

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "\improper Space Cigarettes packet"
	desc = "The most popular brand of cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	item_state = "cigpacket"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	icon_type = "cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette/space_cigarette
	custom_price = PRICE_ALMOST_CHEAP
	var/spawn_coupon = TRUE

/obj/item/storage/fancy/cigarettes/attack_self(mob/user)
	if(contents.len == 0 && spawn_coupon)
		to_chat(user, "<span class='notice'>You rip the back off \the [src] and get a coupon!</span>")
		var/obj/item/coupon/attached_coupon = new
		user.put_in_hands(attached_coupon)
		attached_coupon.generate()
		attached_coupon = null
		spawn_coupon = FALSE
		name = "discarded cigarette packet"
		desc = "An old cigarette packet with the back torn off, worth less than nothing now."
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.max_items = 0
		return
	return ..()

/obj/item/storage/fancy/cigarettes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to extract contents.</span>"
	if(spawn_coupon)
		. += "<span class='notice'>There's a coupon on the back of the pack! You can tear it off once it's empty.</span>"

/obj/item/storage/fancy/cigarettes/AltClick(mob/living/carbon/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, "<span class='warning'>Your hands are full!</span>")
		return	
	var/obj/item/lighter/L = locate() in contents
	if(L)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, L, user)
		user.put_in_hands(L)
		to_chat(user, "<span class='notice'>You take \a [L] out of the pack.</span>")
		return TRUE
	var/obj/item/clothing/mask/cigarette/W = locate() in contents
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")
	return TRUE

/obj/item/storage/fancy/cigarettes/update_icon_state()
	if(!contents.len)
		icon_state = "[initial(icon_state)]_empty"
	else if(fancy_open)
		icon_state = initial(icon_state)

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(!fancy_open || !contents.len)
		return
	. += "[icon_state]_open"
	var/cig_position = 1
	for(var/C in contents)
		var/mutable_appearance/inserted_overlay = mutable_appearance(icon)

		if(istype(C, /obj/item/lighter/greyscale))
			inserted_overlay.icon_state = "lighter_in"
		else if(istype(C, /obj/item/lighter))
			inserted_overlay.icon_state = "zippo_in"
		else
			inserted_overlay.icon_state = "cigarette"

		inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[cig_position]"
		. += inserted_overlay
		cig_position++

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(M != user || !istype(M))
		return ..()
	var/obj/item/clothing/mask/cigarette/cig = locate(/obj/item/clothing/mask/cigarette) in contents
	if(cig)
		if(!user.wear_mask && !(SLOT_WEAR_MASK in M.check_obscured_slots()))
			var/obj/item/clothing/mask/cigarette/W = cig
			SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, M)
			M.equip_to_slot_if_possible(W, SLOT_WEAR_MASK)
			contents -= W
			to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
		else
			return ..()
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "dromedary"
	spawn_type = /obj/item/clothing/mask/cigarette/dromedary

/obj/item/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "uplift"
	spawn_type = /obj/item/clothing/mask/cigarette/uplift

/obj/item/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robust"
	spawn_type = /obj/item/clothing/mask/cigarette/robust

/obj/item/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustg"
	spawn_type = /obj/item/clothing/mask/cigarette/robustgold

/obj/item/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313."
	icon_state = "carp"
	spawn_type = /obj/item/clothing/mask/cigarette/carp

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndie"
	spawn_type = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/nicotine

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims
	name = "\improper Shady Jim's Super Slims packet"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/shadyjims

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "\improper Xeno Filtered packet"
	desc = "Loaded with 100% pure slime. And also nicotine."
	icon_state = "slime"
	spawn_type = /obj/item/clothing/mask/cigarette/xeno

/obj/item/storage/fancy/cigarettes/cigpack_cannabis
	name = "\improper Freak Brothers' Special packet"
	desc = "A label on the packaging reads, \"Endorsed by Phineas, Freddy and Franklin.\""
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/cannabis

/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker
	name = "\improper Leary's Delight packet"
	desc = "Banned in over 36 galaxies."
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/mindbreaker

/obj/item/storage/fancy/rollingpapers
	name = "rolling paper pack"
	desc = "A pack of Nanotrasen brand rolling papers."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper_pack"
///The value in here has NOTHING to do with icons. It needs to be this for the proper examine.
	icon_type = "rolling paper"
	spawn_type = /obj/item/rollingpaper
	custom_price = PRICE_REALLY_CHEAP

/obj/item/storage/fancy/rollingpapers/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.can_hold = typecacheof(list(/obj/item/rollingpaper))

///Overrides to do nothing because fancy boxes are fucking insane.
/obj/item/storage/fancy/rollingpapers/update_icon_state()
	return

/obj/item/storage/fancy/rollingpapers/update_overlays()
	. = ..()
	if(!contents.len)
		. += "[icon_state]_empty"

/////////////
//CIGAR BOX//
/////////////

/obj/item/storage/fancy/cigarettes/cigars
	name = "\improper premium cigar case"
	desc = "A case of premium cigars. Very expensive."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarcase"
	w_class = WEIGHT_CLASS_NORMAL
	icon_type = "premium cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar
	spawn_coupon = FALSE

/obj/item/storage/fancy/cigarettes/cigars/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.can_hold = typecacheof(list(/obj/item/clothing/mask/cigarette/cigar))

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	if(fancy_open)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/storage/fancy/cigarettes/cigars/update_overlays()
	. = ..()
	if(!fancy_open)
		return
	var/cigar_position = 0 //to keep track of the pixel_x offset of each new overlay.
	for(var/obj/item/clothing/mask/cigarette/cigar/smokes in contents)
		var/mutable_appearance/cigar_overlay = mutable_appearance(icon, "[smokes.icon_off]")
		cigar_overlay.pixel_x = 3 * cigar_position
		. += cigar_overlay
		cigar_position++

/obj/item/storage/fancy/cigarettes/cigars/cohiba
	name = "\improper Cohiba Robusto cigar case"
	desc = "A case of imported Cohiba cigars, renowned for their strong flavor."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/cohiba

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "\improper premium Havanian cigar case"
	desc = "A case of classy Havanian cigars."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/havana

/*
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy/heart_box
	name = "heart-shaped box"
	desc = "A heart-shaped box for holding tiny chocolates."
	icon = 'icons/obj/food/containers.dmi'
	item_state = "chocolatebox"
	icon_state = "chocolatebox"
	icon_type = "chocolate"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	spawn_type = /obj/item/reagent_containers/food/snacks/tinychocolate

/obj/item/storage/fancy/heart_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 8
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/tinychocolate))

/obj/item/storage/fancy/nugget_box
	name = "nugget box"
	desc = "A cardboard box used for holding chicken nuggies."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	icon_type = "nugget"
	spawn_type = /obj/item/reagent_containers/food/snacks/nugget

/obj/item/storage/fancy/nugget_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/nugget))

/obj/item/storage/fancy/cracker_pack
	name = "cracker pack"
	desc = "A pack of delicious crackers. Keep away from parrots!"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "crackerbox"
	icon_type = "cracker"
	spawn_type = /obj/item/reagent_containers/food/snacks/cracker

/obj/item/storage/fancy/cracker_pack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.can_hold = typecacheof(list(/obj/item/reagent_containers/food/snacks/cracker))

/*
 * Ring Box
 */

/obj/item/storage/fancy/ringbox
	name = "ring box"
	desc = "A tiny box covered in soft red felt made for holding rings."
	icon = 'icons/obj/ring.dmi'
	icon_state = "gold ringbox"
	icon_type = "gold ring"
	w_class = WEIGHT_CLASS_TINY
	spawn_type = /obj/item/clothing/gloves/ring

/obj/item/storage/fancy/ringbox/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.can_hold = typecacheof(list(/obj/item/clothing/gloves/ring))

/obj/item/storage/fancy/ringbox/diamond
	icon_state = "diamond ringbox"
	icon_type = "diamond ring"
	spawn_type = /obj/item/clothing/gloves/ring/diamond

/obj/item/storage/fancy/ringbox/silver
	icon_state = "silver ringbox"
	icon_type = "silver ring"
	spawn_type = /obj/item/clothing/gloves/ring/silver
