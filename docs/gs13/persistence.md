# Native body and cloning persistence

## Validated cloning compatibility

The native cloning scanner now captures an independent sanitized GS13 policy snapshot and its originating character slot. Clone creation restores that scan-time snapshot without requiring a connected client or reading whichever character slot is currently selected. Weight rates, allowed sources, appearance choices, and fluid production permission therefore remain usable on the cloned body. Later edits to the source body, scan, and clone do not alias one another. Older scan records use disabled compatible defaults and no invented slot association.

Policy restoration does not apply next-spawn settings over the physical DNA. Birth anatomy and physical starting scale still come from the scanned DNA; active organ products, stored fluid, chemical effects, and injuries remain separate. Ordinary DNA identity transfer carries birth anatomy without copying another body's live permissions or saved-character association. Existing mind transfers retain the destination body's policy.

Native cloning grows non-vital limbs in stages while retaining its vital torso. Optional organs created from birth DNA remain in that torso throughout growth and ejection, with the same physical identity. No extra ejection/regrowth hook is needed. Ordinary appearance refreshes cannot regrow a later removed organ. Source physical Neutron alterations remain on the original organ; a new cloned organ uses its birth product and initially configured contents.

Three native integration tests cover scan-time policy isolation and real clone creation, a complete native pod limb-growth/ejection cycle with physical organ identity and birth-state preservation, and older scans versus ordinary DNA identity changes. Checkpoint `e3b038775cef81c76c0de22e92f77e7c96bcbe2c` passed 259 focused / 314 full native tests, zero compiler errors/warnings, no runtime failures, UI checks, and live MariaDB in [run 40168066763](https://github.com/bobatochaps/Paradisefunnything/actions/runs/40168066763).

## Remaining persistence gates

Direct player SQL save/load, reconnects, additional respawn and species/body-creation consumers, persistent fat/muscle rules from the remaining source providers, full inherited anatomy state, and live client workflows remain open. Passing cloning tests does not close the broader interface/persistence milestone.
