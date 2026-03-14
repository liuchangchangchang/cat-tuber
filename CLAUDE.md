# Cat Tuber - Idle Tycoon Game

## Project
- Godot 4.3+, GDScript, portrait mode (540x960 viewport)
- iOS + Android target
- Placeholder visuals (ColorRect) for MVP

## Architecture
- Autoloads: GameManager (state), SaveManager (persistence)
- Systems: economy.gd, house_prestige.gd, destruction.gd, offline_earnings.gd (all static functions)
- Signal-driven: all UI listens to GameManager signals, no cross-scene references
- Data-driven: balance/items/houses defined in data/*.json

## Conventions
- Use `class_name` for systems (Economy, HousePrestige, Destruction, OfflineEarnings, BigNumber)
- Scenes: .tscn + .gd pairs in src/scenes/ and src/ui/
- Tests use GUT framework in tests/ directory

## Key Formulas
- Item cost: `floor(base_cost * cost_multiplier ^ owned_count)`
- Total CPS: `sum(base_prod * count) * house_mult`
- Tap value: `floor(tap_bonus * (1 + total_owned * 0.05) * house_mult)`
