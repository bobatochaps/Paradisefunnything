#!/usr/bin/env python3
"""Rebuild the GS13 scope inventory from a pinned, separate source checkout.

This is a lexical discovery aid, not a DM parser or a feature-parity test.
Run from the Paradise root: python3 tools/gs13/audit_source.py ../gs13-source
"""

import argparse
import hashlib
import json
import re
import subprocess
from collections import Counter, defaultdict
from pathlib import Path

SOURCE_REV = "ec3ad13bd34b64451813004e32892d49de745404"
ORIGINAL_BASE = "7084a06407db70b41389045dd38f54ae3eb2d1f1"
TARGET_REV = "4657875a140bf9b49416a154fe4bc4cd364ce925"
SOURCE_MERGE_BASE = "2968992d556348d5ac3815c034614e441faa8261"
SOURCE_REPOSITORY = "Gain-Station-13/GS13-Blubberstation"
SOURCE_REPOSITORY_ID = 991425722
SOURCE_URL = f"https://github.com/{SOURCE_REPOSITORY}/blob/{SOURCE_REV}/"

# Explicitly identified adapters. This means partial implementation, not parity.
# File names are source-relative after modular_gs/; target files are native adapters.
ADAPTERS = {
    "code/controllers/configuration/entries/helplessness.dm": ["helplessness"],
    "code/datums/_helplessness.dm": ["helplessness"],
    "code/datums/helplessness/helplessness.dm": ["helplessness", "helplessness_effects", "helplessness_equipment", "field_of_view"],
    "code/datums/quirks/negative/negative_quirks.dm": ["quirks"],
    "code/mechanics/chair_brekage.dm": ["helplessness_equipment"],
    "code/mechanics/stuckage.dm": ["door_stuckage"],
    "code/mechanics/xwg.dm": ["weight_size"],
    "code/modules/client/preferences/helplessness_prefs.dm": ["preferences", "helplessness"],
    "code/modules/mob/living/carbon/weight_helpers.dm": ["weight", "body_size"],
    "code/mechanics/fatness.dm": ["weight", "preferences"],
    "code/mechanics/muscle.dm": ["weight"],
    "code/mechanics/fullness.dm": ["fullness"],
    "code/mechanics/fatness/weight_gain_rate.dm": ["weight_rates"],
    "code/mechanics/fatness/fatness_hiders.dm": ["weight_hiders"],
    "code/mechanics/effective_fatness.dm": ["weight"],
    "code/mechanics/calorite.dm": ["calorite", "calorite_construction"],
    "code/mechanics/calorite_glass.dm": ["calorite_glass"],
    "code/mechanics/fattening_trap.dm": ["magic_traps"],
    "code/obj/weapons/energy_guns.dm": ["weapons"],
    "code/obj/weapons/ammo_casings.dm": ["weapons"],
    "code/obj/weapons/melee.dm": ["melee"],
    "code/obj/weapons/caloray.dm": ["caloray"],
    "code/obj/weapons/feeder_ebow.dm": ["weapon_consumables"],
    "code/obj/items/bluespace_belt.dm": ["equipment", "weight_hiders"],
    "code/obj/items/memento_calori.dm": ["memento_calori"],
    "code/obj/items/portable_blender.dm": ["portable_blender"],
    "code/machinery/feeding_tube.dm": ["feeding_machine"],
    "code/machinery/adipoelectric_generator.dm": ["adipoelectric"],
    "code/machinery/adipoelectric_transformer.dm": ["adipoelectric"],
    "code/datums/diseases/advance/symptoms/weight_gain.dm": ["virology"],
    "code/datums/diseases/advance/symptoms/berry.dm": ["blueberry_sources"],
    "code/datums/status_effects/fatstun.dm": ["fat_stun"],
    "code/datums/components/fattening.dm": ["fattening_component"],
    "code/datums/components/fattening_door.dm": ["calorite_construction"],
    "code/datums/components/weight_scale.dm": ["equipment"],
    "code/clothing/calorite_collar.dm": ["collars"],
    "code/clothing/bluespace_collar.dm": ["collars"],
    "code/modules/borg/feeding_tools.dm": ["cyborg_feeding"],
    "code/modules/hydroponics/lipoplant.dm": ["hydroponics"],
    "code/modules/hydroponics/munchies_weed.dm": ["hydroponics"],
    "code/modules/hydroponics/grown/milkmelon.dm": ["hydroponics"],
    "code/modules/hydroponics/grown/berries.dm": ["blueberry_sources"],
    "code/modules/berry/clothing/collar.dm": ["antiburst_collar", "bursting"],
    "code/modules/mob/living/bursting.dm": ["bursting"],
    "code/modules/mob/living/carbon/carbon_defines.dm": ["weight", "transformations", "bursting"],
    "code/modules/mob/living/carbon/human/human_defines.dm": ["bursting"],
    "code/modules/mob/living/genital_sprite_accessories.dm": ["weight_appearance"],
    "code/modules/mob/living/genitals.dm": ["fluid_organs", "anatomy_preferences", "weight_appearance", "anatomy_appearance", "body_shape_dna"],
    "code/modules/mob/living/species.dm": ["weight", "weight_appearance", "helplessness"],
    "code/modules/client/preferences/genitals.dm": ["anatomy_preferences", "preferences", "weight_appearance", "anatomy_appearance", "body_shape_dna"],
    "code/modules/clothing/under/jobs/modular_items.dm": ["weight_appearance", "anatomy_appearance", "modular_clothing"],
    "code/modules/clothing/under/dual_tone_jumpsuit.dm": ["modular_clothing"],
    "code/modules/clothing/under/bunny_suit.dm": ["modular_costume", "modular_clothing"],
    "code/modules/clothing/under/button_up.dm": ["modular_shirts", "modular_clothing"],
    "code/modules/clothing/under/jobs/turtleneck.dm": ["modular_shirts", "modular_clothing"],
    "code/modules/clothing/under/jobs/modular_clothing/button_up.dm": ["modular_shirt_variants", "modular_shirts", "modular_clothing"],
    "code/modules/clothing/under/jobs/modular_clothing/turtleneck.dm": ["modular_shirt_variants", "modular_shirts", "modular_clothing"],
    "code/modules/clothing/under/jobs/modular_clothing/dual_tone.dm": ["modular_clothing_variants", "modular_clothing"],
    "code/modules/loadout/under.dm": ["clothing_distribution", "modular_clothing_distribution"],
    "code/modules/vending/wardrobes.dm": ["clothing_distribution", "modular_clothing_distribution"],
    "code/modules/surgery/organs/internal/stomach/_stomach.dm": ["weight", "fullness", "digestive_organs", "digestion", "stomach_contents", "stomach_surgery", "coated_pills"],
    "code/modules/mod/mod_exoskeleton.dm": ["mod_exoskeleton"],
    "code/modules/mod/modules/modules_fat.dm": ["mod_modules"],
    "code/modules/surgery/organs/augments.dm": ["nutritech_implants"],
    "code/modules/reagents/chemistry/reagents/fermi_fat.dm": ["chemistry"],
    "code/modules/reagents/chemistry/reagents/fatty_drinks.dm": ["chemistry"],
    "code/modules/reagents/chemistry/recipes/fatdrinks.dm": ["chemistry"],
    "code/modules/reagents/chemistry/recipes/fatchem.dm": ["chemistry"],
    "code/modules/reagents/chemistry/reagents/food_reagents.dm": ["chemistry"],
    "code/modules/reagents/chemistry/reagents/consumable_reagents.dm": ["chemistry"],
    "code/modules/reagents/chemistry/reagents/blueberry.dm": ["blueberry", "transformations", "bursting"],
    "code/modules/reagents/chemistry/reagents/starshine.dm": ["starshine", "transformations", "fluid_organs"],
    "code/modules/spells/spells_type/touch/add_weight.dm": ["magic"],
    "code/modules/spells/spells_type/conjure/traps.dm": ["magic_traps"],
    "code/modules/weapons/grenades.dm": ["weapon_consumables"],
    "code/modules/weapons/magic/wand.dm": ["magic"],
    "code/modules/client/preferences/fatness_preferences.dm": ["preferences", "bursting"],
    "code/modules/client/preferences/wg_source_preferences.dm": ["preferences"],
    "code/modules/hud/BFI.dm": ["weight_hud"],
    "code/modules/hud/alert.dm": ["alerts"],
    "code/modules/mob/living/carbon/examine.dm": ["examine"],
    "code/modules/mob/living/carbon/calorite_poisoning.dm": ["calorite"],
    "code/modules/projectiles/projectiles.dm": ["weapons"],
    "code/modules/projectiles/projectile.dm": ["weapons"],
    "code/modules/uplink/uplink_items/adipowarfare.dm": ["weapon_distribution"],
}

INHERITED_ADAPTERS = {
    "code/datums/components/fov_handler.dm": ["field_of_view"],
    "code/modules/mob/living/living_fov.dm": ["field_of_view"],
    "code/_onclick/hud/rendering/render_plate.dm": ["field_of_view"],
    "code/modules/surgery/organs/internal/stomach/_stomach.dm": ["digestive_organs", "digestion", "weight", "fullness", "stomach_contents", "stomach_surgery", "coated_pills"],
    "code/__DEFINES/DNA.dm": ["digestive_organs"],
    "code/__DEFINES/stat.dm": ["digestive_organs"],
    "code/__DEFINES/~~bubber_defines/DNA.dm": ["weight_appearance", "preferences", "body_shape_dna"],
    "code/modules/surgery/organs/_organ.dm": ["digestive_organs", "stomach_surgery"],
    "code/game/objects/items.dm": ["stomach_contents"],
    "code/__DEFINES/reagents.dm": ["coated_pills"],
    "code/modules/reagents/reagent_containers/pill.dm": ["coated_pills", "stomach_contents", "digestion"],
    "code/modules/reagents/chemistry/machinery/chem_master.dm": ["coated_pills"],
    "modular_skyrat/modules/customization/modules/surgery/organs/genitals.dm": ["fluid_organs", "anatomy_preferences", "weight_appearance", "anatomy_appearance", "body_shape_dna"],
    "modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/_genital.dm": ["fluid_organs"],
    "modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/breasts.dm": ["fluid_organs", "anatomy_appearance"],
    "modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/testicles.dm": ["fluid_organs"],
    "modular_skyrat/modules/modular_items/lewd_items/code/lewd_organs/vagina.dm": ["fluid_organs"],
    "modular_skyrat/master_files/code/modules/client/preferences/genitals.dm": ["anatomy_preferences", "preferences", "fluid_organs", "weight_appearance", "anatomy_appearance", "body_shape_dna"],
    "modular_skyrat/modules/modular_items/lewd_items/code/lewd_chemistry/reagents/breast_milk.dm": ["fluid_organs"],
    "modular_skyrat/modules/modular_items/lewd_items/code/lewd_chemistry/reagents/cum.dm": ["fluid_organs"],
}

RULES = [
    ("body-and-appearance", r"customization|taur|clothing|sprite_accessories|genital|fatrousal|effective_fatness"),
    ("preferences-and-core", r"preferences|__DEFINES|__HELPERS|_globalvars|mechanics/(fatness|muscle|fullness|persistent_fat)|mob/living/(carbon|species|fullness)|weighing|hud"),
    ("helplessness-and-transformations", r"helplessness|stuckage|bursting|berry|blueberry|starshine|water_sponge|chair_brekage|xwg|burpslurring|transformation"),
    ("chemistry-food-botany", r"reagents|food_and_drinks|hydroponics|incense|candy"),
    ("atmosphere-and-materials", r"atmospherics|fattening_gasses|calorite|ores_coins|sheets|tiles"),
    ("equipment-and-abilities", r"weapons|projectile|spells|fattening_trap|mod/|borg|memento|bluespace|portable_blender|fattening\.dm"),
    ("species-medical-and-quirks", r"quirks|mutations|diseases|surgery|mobs/|nanites|nifs|vore/"),
    ("machinery-and-power", r"machinery|power|gym|plumbing|feeding_tube"),
    ("distribution-and-research", r"cargo|research|uplink|vending|loadout|xenoarch|outfits"),
    ("world-and-round", r"mapping|ruins|condos|storyteller|jobs|events|voting|shuttle|holiday|bitrunning|configuration"),
]


def git(root, *args):
    return subprocess.check_output(["git", "-C", str(root), *args])


def strip_comments(text):
    # Preserve strings and line numbers; nested DM block comments are handled.
    out, i, depth = [], 0, 0
    while i < len(text):
        if depth:
            if text.startswith("/*", i):
                depth += 1
                i += 2
            elif text.startswith("*/", i):
                depth -= 1
                i += 2
            else:
                out.append("\n" if text[i] == "\n" else " ")
                i += 1
        elif text.startswith("/*", i):
            depth, i = 1, i + 2
        elif text.startswith("//", i):
            end = text.find("\n", i)
            i = len(text) if end < 0 else end
        elif text[i] in "\"'":
            quote = text[i]
            out.append(quote)
            i += 1
            while i < len(text):
                ch = text[i]
                out.append(ch)
                i += 1
                if ch == "\\" and i < len(text):
                    out.append(text[i])
                    i += 1
                elif ch == quote:
                    break
        else:
            out.append(text[i])
            i += 1
    return "".join(out)


def domain(path):
    for name, pattern in RULES:
        if re.search(pattern, path):
            return name
    return "world-content-and-misc"


def read_reviewed_gates(root, section="entries", hash_field="sha256"):
    """Retain semantic review notes only for unchanged files at the same pin."""
    try:
        previous = json.loads((root / "docs/gs13/source_inventory.json").read_text())
    except (OSError, ValueError):
        return {}
    if not isinstance(previous, dict) or previous.get("source_revision") != SOURCE_REV:
        return {}
    entries = previous.get(section, [])
    if not isinstance(entries, list):
        return {}
    return {
        (entry["source"], entry[hash_field]): entry["remaining_gate"]
        for entry in entries
        if isinstance(entry, dict) and all(isinstance(entry.get(key), str) for key in ("source", hash_field, "remaining_gate"))
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    args = parser.parse_args()
    source = args.source.resolve()
    root = Path(__file__).resolve().parents[2]
    reviewed_gates = read_reviewed_gates(root)
    inherited_gates = read_reviewed_gates(root, "reviewed_inherited_adapters", "git_blob_sha")
    if git(source, "rev-parse", "HEAD").decode().strip() != SOURCE_REV:
        parser.error(f"Source checkout must be exactly {SOURCE_REV}")
    tracked = sorted(p.decode() for p in git(source, "ls-files", "-z").split(b"\0") if p)
    dm_files = [p for p in tracked if p.endswith(".dm")]
    modular = [p for p in dm_files if p.startswith("modular_gs/")]
    includes = set(p.replace("\\", "/") for p in re.findall(r'^#include\s+"([^"]+)"', (source / "tgstation.dme").read_text(), re.M))
    clean, definitions, providers = {}, {}, defaultdict(set)
    for path in dm_files:
        text = strip_comments((source / path).read_text(errors="replace"))
        clean[path] = text
        declarations = sorted(set(re.findall(r"^(/[\w/]+)", text, re.M)))
        definitions[path] = declarations
        for declaration in declarations:
            providers[declaration].add(path)
    entries = []
    for path in modular:
        text = clean[path]
        dependencies = set()
        references = set(re.findall(r"/(?:datum|obj|mob|turf|area|atom|client)(?:/[\w]+)+", text))
        # Type declarations also depend on their parent types.
        references |= {d.rsplit("/", 1)[0] for d in definitions[path] if "/" in d[1:]}
        for reference in references:
            while reference:
                matches = providers.get(reference, set()) - {path}
                if matches:
                    dependencies.update(matches)
                    break
                reference = reference.rsplit("/", 1)[0]
        adapters = [f"code/modules/gs13/{name}.dm" for name in ADAPTERS.get(path.removeprefix("modular_gs/"), [])]
        for adapter in adapters:
            if not (root / adapter).exists():
                raise ValueError(f"Missing declared adapter: {adapter}")
        assets = sorted(set(re.findall(r"'([^'\n]+\.(?:dmi|ogg|png|wav|dmm|json))'", text)))
        source_hash = hashlib.sha256((source / path).read_bytes()).hexdigest()
        entries.append({
            "source": path,
            "sha256": source_hash,
            "domain": domain(path),
            "root_dme_entry": path in includes,
            "status": "partial-adapter" if adapters else "needs-semantic-audit",
            "target_adapters": adapters,
            "declarations": definitions[path],
            "direct_type_provider_candidates": sorted(dependencies),
            "asset_literals": assets,
            "remaining_gate": reviewed_gates.get((path, source_hash), "Audit behavior, dependencies, assets, acquisition, preferences, lifecycle, and native integration tests."),
        })
    hooks = []
    marker = re.compile(r"GS13|modular_gs|Blubberstation|Gain Station", re.I)
    extensions = {".dm", ".dme", ".ts", ".tsx", ".js", ".json", ".txt", ".toml", ".yml", ".yaml", ".dmm"}
    for path in tracked:
        if path.startswith("modular_gs/") or Path(path).suffix not in extensions:
            continue
        lines = (source / path).read_text(errors="replace").splitlines()
        hits = [i for i, line in enumerate(lines, 1) if marker.search(line)]
        if hits:
            hooks.append({"source": path, "marker_lines": hits, "status": "needs-semantic-audit"})
    candidates = sorted({p for e in entries for p in e["direct_type_provider_candidates"] if p.startswith(("modular_skyrat/", "modular_zubbers/"))})
    delta = []
    for row in git(source, "diff", "--name-status", "--no-renames", SOURCE_MERGE_BASE, SOURCE_REV).decode().splitlines():
        change, path = row.split("\t")
        delta.append({"source": path, "change": change, "status": "needs-semantic-audit"})
    outside_delta = [row for row in delta if not row["source"].startswith("modular_gs/")]
    upstream_changes = git(root, "diff", "--name-status", ORIGINAL_BASE, TARGET_REV).decode().splitlines()
    inherited_reviews = []
    for path, names in INHERITED_ADAPTERS.items():
        targets = [f"code/modules/gs13/{name}.dm" for name in names]
        if not all((root / target).is_file() for target in targets):
            raise ValueError(f"Missing inherited adapter: {path}")
        source_blob = git(source, "rev-parse", f"{SOURCE_REV}:{path}").decode().strip()
        inherited_reviews.append({
            "source": path,
            "git_blob_sha": source_blob,
            "status": "partial-adapter", "target_adapters": targets,
            "remaining_gate": inherited_gates.get((path, source_blob), "Audit remaining inherited behavior, preferences, lifecycle, native integration, and client gameplay."),
        })
    result = {
        "schema": 1, "source_revision": SOURCE_REV, "source_parent": "Bubberstation/Bubberstation",
        "source_repository": SOURCE_REPOSITORY, "source_repository_id": SOURCE_REPOSITORY_ID,
        "original_paradise_base": ORIGINAL_BASE, "audited_paradise_master": TARGET_REV,
        "source_bubber_merge_base": SOURCE_MERGE_BASE,
        "limitations": ["Lexical discovery is not a compiler dependency graph.", "Root DME membership does not evaluate conditional compilation.", "Provider candidates include overrides and require human review.", "The historical branch delta includes additions, changes, and deletions; each needs a semantic disposition, not automatic copying.", "An adapter and passing focused tests do not establish complete feature parity."],
        "entries": entries, "outside_module_marker_candidates": hooks,
        "inherited_provider_candidates": candidates, "source_branch_delta": delta,
        "reviewed_inherited_adapters": inherited_reviews,
        "paradise_upstream_changes": upstream_changes,
    }
    out = root / "docs/gs13"
    out.mkdir(parents=True, exist_ok=True)
    (out / "source_inventory.json").write_text(json.dumps(result, indent=2) + "\n")
    counts = Counter(e["domain"] for e in entries)
    lines = ["# GS13 source inventory", "", f"Source: `{SOURCE_REV}`. Audited Paradise master: `{TARGET_REV}`.", "",
             f"{len(entries)} modular DM files; {sum(e['root_dme_entry'] for e in entries)} listed in the root DME. {len(hooks)} outside-module files contain attribution/integration markers. {len(candidates)} inherited provider files are lexical dependency candidates.", "",
             f"Historical Bubber merge base: `{SOURCE_MERGE_BASE}`. The exact source branch delta contains {len(delta)} file changes, including {len(outside_delta)} outside `modular_gs`; this also captures unmarked changes and deletions.", "",
             "These are discovery counts, not a completion percentage. No file is marked complete until its semantic and gameplay gates are checked. `partial-adapter` means an existing adapter was identified; `needs-semantic-audit` does not assert that every declaration is missing.", "",
             "Regenerate with `python3 tools/gs13/audit_source.py ../gs13-source`. Existing semantic gate notes are retained only for unchanged files at the same source pin. Detailed declarations, provider candidates, asset literals, hashes, marker lines, and upstream changes are in [source_inventory.json](source_inventory.json). See [completion_plan.md](completion_plan.md) for the dependency order and release gates.", "",
             "| Domain | Source files |", "|---|---:|"]
    lines += [f"| {name} | {count} |" for name, count in sorted(counts.items())]
    lines += ["", "## File checklist", "", "| Source | Status | Identified native adapters |", "|---|---|---|"]
    for e in entries:
        adapters = ", ".join(f"`{p}`" for p in e["target_adapters"]) or "Audit required"
        lines.append(f"| [{e['source']}]({SOURCE_URL}{e['source']}) | {e['status']} | {adapters} |")
    lines += ["", "## Outside-module markers", "", "These are candidates, including comments and configuration references. The historical delta below also covers unmarked changes.", "", "| File | Marker lines |", "|---|---|"]
    for h in hooks:
        lines.append(f"| [{h['source']}]({SOURCE_URL}{h['source']}) | {', '.join(map(str, h['marker_lines'][:12]))}{' …' if len(h['marker_lines']) > 12 else ''} |")
    lines += ["", "## Historical changes outside modular_gs", "", "A/M/D mean added/modified/deleted relative to the historical Bubber merge base. All require semantic review; inherited systems may also be required when unchanged in this delta.", "", "| Change | File |", "|---|---|"]
    lines += [f"| {row['change']} | `{row['source']}` |" for row in outside_delta]
    lines += ["", "## Reviewed inherited dependencies", "",
              "These pinned provider files have partial native adapters and are recorded separately from the modular file count and lexical provider candidates. Detailed remaining gates are in the JSON inventory. Source assets and native adaptations are described in the vision, anatomy, fluid-organ, and digestion implementation records; direct client verification and other inherited behavior remain open.", "",
              "| Source | Blob | Status | Native adapters |", "|---|---|---|---|"]
    lines += [f"| `{row['source']}` | `{row['git_blob_sha']}` | {row['status']} | {', '.join(f'`{p}`' for p in row['target_adapters'])} |" for row in inherited_reviews]
    (out / "source_inventory.md").write_text("\n".join(lines) + "\n")
    print(json.dumps({"modular_files": len(entries), "partial_adapters": sum(bool(e['target_adapters']) for e in entries), "outside_marker_files": len(hooks), "inherited_provider_candidates": len(candidates), "source_branch_changes": len(delta), "outside_source_changes": len(outside_delta), "upstream_changed_files": len(upstream_changes), "json_bytes": (out / 'source_inventory.json').stat().st_size}))


if __name__ == "__main__":
    main()
