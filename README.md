# research-multipliers

[![Factorio Download Count][factorio-download-count-badge]][factorio-mods-page] [![GitHub Release Version][github-release-badge]][github-latest-release]

A mod for Factorio, providing configurable multipliers for research.

- Supports decimal precision multipliers allowing finer controls on research amounts.
- Category-based, pack-based, and individual technology multipliers for advanced control.
  - Categories are more loosely defined groups of technologies, such as "Essential", "Infinite", "Interplanetary"; learn more [here](#Categories).
    <!-- - Individual technologies can be specified using a custom format, see [here](#custom-format) for how it works. -->
- Expansion Support
  - [Space Age][space-age]

## Usage

1. Install the mod via, either via the in-game mod portal, downloading from the [Factorio Mod Portal][factorio-mods-page], or downloading from the [GitHub Releases][github-latest-release].

   - You do not need to unzip the mod, and you don't want the 'Source code' download.
   - For more information on installing mods, see the [Factorio Wiki](https://wiki.factorio.com/index.php?title=Installing_Mods).

2. Launch the game, and configure the mod settings in the 'Startup' section of the mod settings menu.
3. Once configured, the research costs will be updated upon restart.

## Mod Compatibility

I'm still publishing and developing this little tweak mod, so I haven't tested it with anything. Please let me know if you encounter any issues with other mods.

## Configuration

The mod settings are located in the 'Startup' section of the mod settings menu.

_Multipliers_ are numbers (decimal or whole) that multiple the research cost for various technologies.

- Besides category, pack, and custom multipliers, you can also apply a _global multiplier_. This applies to all technologies, regardless of category or pack.
- Negative numbers and 0 are not valid multipliers.
- Very low multipliers that would otherwise cost a technology to cost less than 1 will have their final cost rounded up to 1.

For now, _Science Pack Multipliers_ don't modify the individual pack 'ingredient' costs, but rather the total cost of the technology. The last science pack with a non-1.0 multiplier dictates the technology pack's cost.

<!-- - `Multiplier Mode` changes how multipliers from different sources are handled.
- `Override` means that the last multiplier applied is the one used. This is the default mode.
- `Multiply` means that all multipliers are multiplied together.
  - For example, if you have a global multiplier of 1.5, and a pack multiplier of 1.2, the total multiplier would be 1.8.
- `Pack` works like override, but pack multipliers are multiplied together, although custom multipliers can still override them afterwards.
  - For example, the [Captivity](<https://wiki.factorio.com/Captivity_(research)>) research costs 1000 of each relevant pack; with a Agricultural pack multiplier of 0.5 and an Automation pack multiplier of 2.5, the total multiplier would be 1.25, costing 1250 of each pack.
  - Note: Currently this mode works in a 'flat' manner, meaning that all packs used are multiplied in the exact same way.
- `Max` means that the highest multiplier is used, regardless of source.
- `Min` means that the lowest multiplier is used, regardless of source.
- `Sum` means that all multipliers are added together, regardless of source.
  - Note: This considers the base multiplier being 1, so a multiplier of 1.3 only adds 0.3 to the total multiplier.
  - For example, if it sums multipliers of 1.3, 1.15, and 0.80, the total multiplier would be 1.25 (+0.3, +0.15, -0.20). -->

<!-- ## Custom Format

The custom format allows you to configure individual technologies with a multiplier. This configuration applies last.

The format requires you have the research identifier.

In the textbox labeled 'Custom Multipliers', you can specify the multipliers in the following format:

```plaintext
<research-identifier>=[x]<multiplier>[,<research-identifier>=[x]<multiplier>]
```

- Omitting the `x` will explicitly _set_ the multiplier, instead of multiplying with other multipliers (such as category or pack multipliers). If you have multiplicative mode disabled, this will always be the case.
- Invalid research identifiers will be logged and then ignored.

> [!NOTE]
> Later on, I may add a way to easily acquire research identifiers in-game without using commands. A 'debug' mode could be added, modifying research descriptions to include their internal identifier. -->

## Order

Multipliers are applied in a specific order, and the last one applied is the one used.

1. **Global** multipliers
2. **Pack** multipliers.
   - Applies per-pack in this order:
     ![Automation][automation-icon] ![Logistic][logistic-icon] ![Military][military-icon] ![Chemical][chemical-icon] ![Production][production-icon] ![Utility][utility-icon] ![Space][space-icon] ![Metallurgic][metallurgic-icon] ![Electromagnetic][electromagnetic-icon] ![Agricultural][agricultural-icon] ![Cryogenic][cryogenic-icon] ![Promethium][promethium-icon]
3. **Category** multipliers
   - **Essential**
   - **Interplanetary**
   - **Infinite**
4. **Custom** multipliers

Multipliers set to 1.0 (whether by default or explicitly) are ignored and not taken into consideration when calculating the final multiplier.

## Categories

Categories are the way this mod groups technologies together for easier configuration. The following categories are available for you to configure:

- **Essential** is defined by Factorio, dictated by the 'Show only essential technologies' setting, shown in the Technology tree menu. Includes all research packs, planet discovery research, and the rocket silo technology.
- **Interplanetary** is a loosely defined category for all technologies that require science packs from other planets. This does not mean Space science. This includes T3 modules, turbo belts, artillery, rocket turrets, epic/legendary quality, quantum processors, and so on.
  - Currently, this does not include 'infinite' technologies.
- **Infinite** is a category for all infinite technologies.
  - This does not include the 'finite' level upgrade technologies, such as inserter capacity, transport belt capacity, or level 1-6 of worker robot speed.
  - I may consider adding on an option to include these in the future.

[automation-icon]: ./.assets/Automation.png
[logistic-icon]: ./.assets/Logistic.png
[military-icon]: ./.assets/Military.png
[chemical-icon]: ./.assets/Chemical.png
[production-icon]: ./.assets/Production.png
[utility-icon]: ./.assets/Utility.png
[space-icon]: ./.assets/Space.png
[metallurgic-icon]: ./.assets/Metallurgic.png
[electromagnetic-icon]: ./.assets/Electromagnetic.png
[agricultural-icon]: ./.assets/Agricultural.png
[cryogenic-icon]: ./.assets/Cryogenic.png
[promethium-icon]: ./.assets/Promethium.png
[factorio-mods-page]: https://mods.factorio.com/mod/research-multipliers
[factorio-download-count-badge]: https://img.shields.io/badge/dynamic/json?color=orange&label=Factorio&query=downloads_count&suffix=%20downloads&url=https%3A%2F%2Fmods.factorio.com%2Fapi%2Fmods%2Fresearch-multipliers&style=flat
[github-latest-release]: https://github.com/Xevion/research-multipliers/releases/
[github-release-badge]: https://img.shields.io/github/v/release/Xevion/research-multipliers
[space-age]: https://factorio.com/buy-space-age
