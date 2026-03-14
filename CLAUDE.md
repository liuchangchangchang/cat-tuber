# Cat Tuber - Idle Tycoon Game

## Workflow
- After each modify is made, make a commit.
- Always push all commits to remote in the end.

## Project
- Godot 4.6, GDScript, portrait mode (1080x1920 viewport, keep_width stretch)
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
