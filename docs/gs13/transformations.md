# Transformation implementation record

Source: `Gain-Station-13/GS13-Blubberstation@ec3ad13bd34b64451813004e32892d49de745404`.

This record covers the first two items in the ordered completion queue. It does not close the broader appearance, anatomy, or release milestones.

## Shared body state

Source blueberry juice and Starshine Neutron contribute `124 * volume² / 1000` to apparent BFI through the source hider interface. The native `transformations.dm` adapter aggregates independent, replaceable sources, derives the existing nine body stages, and removes a source when its datum is deleted. The contribution does not rewrite regular fat, permanent fat, DNA, or starting body size. Existing concealment, maximum apparent weight, temporary resizing, and native anatomy still apply.

A dedicated native color priority sits below temporary/admin effects and above washable paint. Clearing the transformation reveals the current underlying colors; it does not restore an old snapshot over paint or a species change made during the effect. The last registered colored transformation has priority within this slot. Removing it reveals the preceding active transformation.

Reagent additions, merges, drainage, transfers, metabolism, live preference edits, and native species changes refresh the state. Effects stay with the physical body across mind transfers and disconnects. A corpse keeps the mass of its retained chemicals and still shrinks when drained. Reagent or body deletion removes the owned state and listeners. Ordinary character/DNA snapshots do not copy active chemical effects to another body.

## Blueberry juice foundation

The independent `blueberry_inflation` setting defaults to false, matching source. It uses the existing character JSON/SQL preference field. An opted-out body immediately discards juice; a live opt-out also removes an existing dose. This setting does not enable ordinary chemical weight gain. Eligible organic carbons use the source color and volume formula. Synthetic species that cannot metabolize the reagent do not receive its body effect. The inherited `no_mob_color` option retains volume growth without recoloring.

The current human appearance adapter displays the resulting stages even when ordinary weight gain is disabled. Other species retain their native silhouette until item 3 supplies their body-specific adapters. The complete source's separate organ/body-shape customization is still pending.

## Disease, production, crops, and treatment

The Berrification symptom is available to native virology and as a direct disease preset. With blueberry transformations enabled it seeds `max(1, stage speed) * 10` juice, then adds `max(stage speed, 0.2) * stage` every twenty seconds. The ordinary chemical/viral weight-gain switches remain separate from this transformation opt-in, matching the source's specific blueberry gate. Native disease treatments/cures remain applicable. Removing all juice cures the infection without granting resistance; an ordinary disease cure stops production and sound while leaving existing juice to drain or metabolize. The source's native symptom API and timing are adapted rather than duplicating its parent-Start call.

Multiple infections share one original sound loop per body. Death mutes it; revival of an active infection restarts it. Disease, source, or body deletion stops and deletes the loop. The symptom releases its body listeners on removal.

Normal berries can mutate into blueberries while retaining their existing mutation choices. The source's low starting potency, yield, production timing, reagent coefficient, and original sprites are retained. Native planting, harvesting, seed extraction, grinding, and juicing supply ordinary acquisition and processing. Grinding extracts transformation juice; the source's juicing product remains ordinary berry juice. Wine strength uses Paradise's 0-to-1 scale.

To collect juice, use an open glass container on a blueberry in **grab intent**. This maps the source secondary-click action to Paradise's native intent system. Every one-second dose rechecks the held container, its lid and capacity, adjacency, and the remaining juice. It transfers only blueberry juice, at most ten units and the configured transfer amount per dose, preserving unrelated medicines. Fully draining an infected body also cures Berrification. Native viral contamination is retained on juice collected from an infected host.

Permaberry is a native neutral quirk and can also be acquired from a juice dose of at least 999 units during metabolism. It produces `(0.01 + min(0.49, elapsed seconds / 14693))` units per second, including after death as in source, subject to blueberry opt-in and species metabolism. Paradise processing supplies deciseconds, which are converted once. Fractional production accumulates until a new dose survives the native 0.09-unit removal boundary. Removing the quirk stops its actual processing subsystem.

## Validation and remaining work

Ten native integration tests cover independent sources, source replacement/deletion, color priority and restoration, invalid inputs, preference snapshots and live opt-out, volume merges and drainage, native concealment, species changes, mind/reagent transfers, death/revival, holder/body deletion, and metabolism/colorless juice. Foundation `6c9447f1bd279e35bf3b01cef65e90ede78b7279` passed 173 focused and 228 full native tests with zero compiler errors/warnings, successful UI checks, and live MariaDB validation in [run 40094428981](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40094428981).

Nine additional integration tests cover disease production/timing and native infection/drain cure, shared sound lifecycle, native crop harvesting/extraction/processing, collection bounds and the real attack chain, and Permaberry production/acquisition. Their native CI validation is pending.

Pressure/bursting, anti-burst collars, Starshine, and the final cyborg palette are the next implementation steps. Client-only appearance and gameplay checks remain required. For a client test, enable blueberry transformations, add 50 then 100 units, drain back to zero, and repeat with native paint, a temporary color effect, the modular uniform, concealment, species changes, body transfers, death/revival, and a saved/reloaded character. Verify each recovery reveals the current body appearance. Also test infection production, glass collection with interruptions, normal cures, harvesting and processing the mutation, and Permaberry across reconnects and revival.
