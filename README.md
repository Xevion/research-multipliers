# research-multipliers

[![Factorio Download Count][factorio-download-count-badge]][factorio-mods-page] [![GitHub Release Version][github-release-badge]][github-latest-release]

A mod for Factorio, providing configurable multipliers for research.

- Supports decimal precision multipliers allowing finer controls on research amounts.
- Category-based, pack-based, and individual technology multipliers for advanced control.
  - Categories are more loosely defined groups of technologies, such as "Essential", "Infinite", "Interplanetary"; learn more [here](#Categories).
  - Packs are the various science packs in the game; later on this can be updated to include science packs unique to other mods, such as Space Exploration, Krastorio 2, or Bob's/Angel's.
  - Individual technologies can be specified using a custom format, see [here](#custom-format) for how it works.
- Expansion Support
  - [Space Age][space-age]

## Categories

Categories are the way this mod groups technologies together for easier configuration. The following categories are available for you to configure:

- **Essential** is defined by Factorio, dictated by the 'Show only essential technologies' setting, shown in the Technology tree menu. Includes all research packs, planet discovery research, and the rocket silo technology.
- **Interplanetary** is a loosely defined category for all technologies that require science packs from other planets. This does not mean Space science. This includes T3 modules, turbo belts, artillery, rocket turrets, epic/legendary quality, quantum processors, and so on.
  - Currently, this does not include 'infinite' technologies.
- **Infinite** is a category for all infinite technologies.

[factorio-mods-page]: https://mods.factorio.com/mod/research-multipliers
[factorio-download-count-badge]: https://img.shields.io/badge/dynamic/json?color=orange&label=Factorio&query=downloads_count&suffix=%20downloads&url=https%3A%2F%2Fmods.factorio.com%2Fapi%2Fmods%2Fresearch-multipliers&style=flat
[github-latest-release]: https://github.com/Xevion/research-multipliers/releases/
[github-release-badge]: https://img.shields.io/github/v/release/Xevion/research-multipliers
[space-age]: https://factorio.com/buy-space-age
