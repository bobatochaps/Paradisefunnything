// Native adapter for inherited GS13 living_fov.dm, fov_handler.dm and render_plate.dm.
// Native world planes keep drawing normally. Exports compose a private, lit scene
// whose blurred/dimmed peripheral copy is drawn below fullscreens and the HUD.
/mob/living/proc/add_fov_trait(source, angle)
	if((!istext(source) && !istype(source, /datum)) || !(angle in list(-270, -180, -90, 90, 180, 270)))
		return FALSE
	var/datum/component/gs13_fov/controller = LoadComponent(/datum/component/gs13_fov)
	controller.sources[source] = angle
	controller.update_angle()
	return TRUE

/mob/living/proc/remove_fov_trait(source, angle)
	var/datum/component/gs13_fov/controller = GetComponent(/datum/component/gs13_fov)
	if(!controller)
		return
	controller.sources -= source
	if(!length(controller.sources))
		qdel(controller)
	else
		controller.update_angle()

/mob/living/proc/gs13_fov_angle()
	var/datum/component/gs13_fov/controller = GetComponent(/datum/component/gs13_fov)
	return controller ? controller.angle : 0

/// Source angular predicate, including its nearby 3x3 exception and reverse cones.
/// This supplements native sight/LOS; it does not grant sight through walls.
/mob/living/proc/in_fov(atom/observed, ignore_self = FALSE)
	if(ignore_self && observed == src)
		return TRUE
	if(!has_vision(information_only = TRUE))
		return FALSE
	var/turf/origin = get_turf(src)
	var/turf/target = get_turf(observed)
	if(!origin || !target || origin.z != target.z)
		return FALSE
	var/dx = target.x - origin.x
	var/dy = target.y - origin.y
	if(HAS_TRAIT(src, TRAIT_NEARSIGHT))
		var/mob/living/carbon/human/subject = src
		var/obj/item/clothing/glasses/corrective = ishuman(src) ? subject.glasses : null
		if(!istype(corrective) || !corrective.prescription)
			if(abs(dx) >= 2 || abs(dy) >= 2)
				return FALSE
	var/angle = gs13_fov_angle()
	if(!angle || (abs(dx) <= 1 && abs(dy) <= 1))
		return TRUE
	var/facing_x = (dir & EAST ? 1 : 0) - (dir & WEST ? 1 : 0)
	var/facing_y = (dir & NORTH ? 1 : 0) - (dir & SOUTH ? 1 : 0)
	var/length_product = sqrt((facing_x ** 2 + facing_y ** 2) * (dx ** 2 + dy ** 2))
	if(!length_product)
		return TRUE
	var/difference = arccos(clamp((facing_x * dx + facing_y * dy) / length_product, -1, 1))
	var/half_cone = (360 - abs(angle)) / 2
	return angle > 0 ? difference < half_cone : difference > half_cone

/datum/component/gs13_fov
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/sources = list()
	var/angle = 0
	var/datum/hud/bound_hud
	var/client/bound_client
	var/list/render_objects = list()
	/// PM -> old target and the target assigned by this component.
	var/list/exported_planes = list()
	var/list/relayed_planes = list()
	var/list/temporary_masters = list()
	var/atom/movable/screen/gs13_fov/mask
	var/atom/movable/screen/gs13_fov/peripheral

/datum/component/gs13_fov/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/gs13_fov/RegisterWithParent()
	RegisterSignal(parent, list(COMSIG_MOB_LOGIN, COMSIG_LIVING_REVIVE, COMSIG_MOB_DEATH, COMSIG_GS13_HUD_CHANGED, COMSIG_GS13_VIEW_CHANGED, COMSIG_GS13_PERSPECTIVE_CHANGED), PROC_REF(on_refresh))
	RegisterSignal(parent, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_direction))

/datum/component/gs13_fov/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOB_LOGIN, COMSIG_LIVING_REVIVE, COMSIG_MOB_DEATH, COMSIG_GS13_HUD_CHANGED, COMSIG_GS13_VIEW_CHANGED, COMSIG_GS13_PERSPECTIVE_CHANGED, COMSIG_MOB_LOGOUT, COMSIG_ATOM_DIR_CHANGE))
	clear_rendering()

/datum/component/gs13_fov/Destroy(force = FALSE, silent = FALSE)
	UnregisterFromParent()
	sources.Cut()
	return ..()

/datum/component/gs13_fov/proc/update_angle()
	angle = 0
	for(var/source in sources)
		var/value = sources[source]
		if(!angle || value > angle)
			angle = value
	refresh()

/// Contained bodies see from their outermost container; remote cameras are exempt.
/datum/component/gs13_fov/proc/should_mask(atom/eye)
	var/mob/living/subject = parent
	if(!subject || QDELETED(subject) || !get_turf(subject) || subject.stat == DEAD || !angle)
		return FALSE
	var/atom/outer = subject
	while(outer.loc && !isturf(outer.loc))
		outer = outer.loc
	return eye == subject || eye == outer

/datum/component/gs13_fov/proc/on_refresh(datum/source)
	SIGNAL_HANDLER
	refresh()

/datum/component/gs13_fov/proc/on_logout(datum/source)
	SIGNAL_HANDLER
	clear_rendering()

/datum/component/gs13_fov/proc/on_direction(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	if(mask)
		mask.dir = new_dir

/datum/component/gs13_fov/proc/refresh()
	var/mob/living/subject = parent
	if(!subject.client || !subject.hud_used || !should_mask(subject.client.eye))
		clear_rendering()
		return
	if(bound_hud != subject.hud_used || bound_client != subject.client)
		clear_rendering()
		bound_client = subject.client
		build_pipeline(subject.hud_used)
	update_mask(subject.dir, subject.client.view)
	for(var/atom/movable/screen/plane_master/native as anything in relayed_planes)
		var/atom/movable/screen/gs13_fov/relay = relayed_planes[native]
		if(!QDELETED(native))
			relay.blend_mode = native.blend_mode
	bound_client.screen |= render_objects

/datum/component/gs13_fov/proc/build_pipeline(datum/hud/hud)
	if(QDELETED(hud) || hud.mymob != parent)
		return FALSE
	clear_rendering(FALSE)
	bound_hud = hud
	RegisterSignal(hud, COMSIG_PARENT_QDELETING, PROC_REF(on_hud_deleted))
	var/scene_target = "*gs13_fov_scene_[UID()]"
	var/mask_target = "*gs13_fov_mask_[UID()]"
	var/atom/movable/screen/plane_master/scene = new
	scene.plane = GS13_FOV_SCENE_PLANE
	scene.render_target = scene_target
	render_objects += scene
	var/atom/movable/screen/plane_master/mask_master = new
	mask_master.plane = GS13_FOV_MASK_PLANE
	mask_master.render_target = mask_target
	render_objects += mask_master
	// Include visible native world planes, preserving their blend modes and filters.
	// Existing hidden render targets (emissives/lamps/displacement) remain untouched.
	var/static/list/world_planes = list(PLANE_SPACE, PLANE_SPACE_PARALLAX, FLOOR_PLANE, FLOOR_OVERLAY_PLANE, FLOOR_LIGHTING_LAMPS_GLARE, FLOOR_LIGHTING_LAMPS_SELFGLOW, FLOOR_LIGHTING_LAMPS_PLANE, ABOVE_GAME_PLANE, GAME_PLANE, BLACKNESS_PLANE, AREA_PLANE, SMOKE_PLANE, EMISSIVE_PLANE, POINT_PLANE, COGBAR_PLANE, LIGHTING_PLANE, LIGHTING_LAMPS_GLARE, LIGHTING_EXPOSURE_PLANE, LIGHTING_LAMPS_SELFGLOW, LIGHTING_LAMPS_PLANE, ABOVE_LIGHTING_PLANE, FLOOR_OPENSPACE_PLANE, INFO_TAG_PLANE, BYOND_LIGHTING_PLANE)
	for(var/plane_id in world_planes)
		var/atom/movable/screen/plane_master/native = hud.plane_masters["[plane_id]"]
		if(!native)
			native = new
			native.plane = plane_id
			native.appearance_flags = PLANE_MASTER
			temporary_masters += native
			render_objects += native
		if(copytext(native.render_target, 1, 2) == "*")
			continue
		var/target = native.render_target
		if(!target)
			target = "gs13_fov_[UID()]_[plane_id]"
			exported_planes[native] = list("old" = native.render_target, "assigned" = target)
			native.render_target = target
		var/atom/movable/screen/gs13_fov/relay = new
		relay.plane = GS13_FOV_SCENE_PLANE
		relay.layer = plane_id + 100
		relay.render_source = target
		relay.blend_mode = native.blend_mode
		relayed_planes[native] = relay
		render_objects += relay
	mask = new
	mask.icon = 'modular_gs/icons/upstream/field_of_view.dmi'
	mask.plane = GS13_FOV_MASK_PLANE
	mask.screen_loc = "BOTTOM,LEFT"
	render_objects += mask
	var/atom/movable/screen/gs13_fov/backing = new
	backing.plane = GS13_FOV_OUTPUT_PLANE
	backing.layer = 1
	backing.render_source = mask_target
	backing.color = "#000000"
	render_objects += backing
	peripheral = new
	peripheral.plane = GS13_FOV_OUTPUT_PLANE
	peripheral.layer = 2
	peripheral.render_source = scene_target
	peripheral.add_filter("gs13_fov_blur", 1, gauss_blur_filter(1.8))
	peripheral.add_filter("gs13_fov_mask", 2, alpha_mask_filter(render_source = mask_target))
	peripheral.add_filter("gs13_fov_color", 3, color_matrix_filter(list(0.5,-0.15,-0.15,0, -0.15,0.5,-0.15,0, -0.15,-0.15,0.5,0, 0,0,0,1, 0,0,0,0)))
	render_objects += peripheral
	return TRUE

/datum/component/gs13_fov/proc/update_mask(direction, view_size)
	if(!mask)
		return
	var/list/dimensions = getviewsize(view_size)
	var/matrix/scale = matrix()
	var/reversed = angle < 0 ? -1 : 1
	scale.Scale(reversed * dimensions[1] / 15, reversed * dimensions[2] / 15)
	scale.Translate((dimensions[1] - 15) * 16, (dimensions[2] - 15) * 16)
	mask.transform = scale
	mask.dir = direction
	mask.icon_state = "[angle > 0 ? angle : 360 + angle]"

/datum/component/gs13_fov/proc/on_hud_deleted(datum/source)
	SIGNAL_HANDLER
	clear_rendering()

/datum/component/gs13_fov/proc/clear_rendering(clear_client = TRUE)
	if(bound_client)
		bound_client.screen -= render_objects
	if(clear_client)
		bound_client = null
	if(bound_hud)
		UnregisterSignal(bound_hud, COMSIG_PARENT_QDELETING)
	bound_hud = null
	for(var/atom/movable/screen/plane_master/native as anything in exported_planes)
		var/list/saved = exported_planes[native]
		if(!QDELETED(native) && native.render_target == saved["assigned"])
			native.render_target = saved["old"]
	exported_planes.Cut()
	relayed_planes.Cut()
	QDEL_LIST_CONTENTS(render_objects)
	temporary_masters.Cut()
	mask = null
	peripheral = null

/atom/movable/screen/gs13_fov
	screen_loc = "CENTER"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = KEEP_TOGETHER | NO_CLIENT_COLOR
