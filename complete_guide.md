# The Complete Guide to Building a Mobile Idle Game with Godot 4 + Claude Code

> A step-by-step workflow for autonomous AI-agent game development on Windows.
> Optimized for: Ad-Monetized Idle/Incremental Games | Platform: iOS + Android | Primary Developer: Claude Code (AI Agent) | March 2026

---

## Table of Contents

1. Why This Stack: Godot 4 + GDScript + Idle Game
2. Prerequisites: Windows Environment Setup
3. The CLAUDE.md File: Your AI Agent's Brain
4. Project Structure: Designed for AI Autonomy
5. The Autonomous Development Loop
6. Phase 1: Core Idle Game Mechanics
7. Phase 2: UI and Visual Polish
8. Phase 3: Ad Monetization with AdMob
9. Phase 4: Save System and Persistence
10. Phase 5: Testing and Validation
11. Phase 6: Building for Mobile
12. Phase 7: CI/CD Pipeline
13. Advanced: Prompt Engineering for Game Dev
14. Monetization Strategy and Ad Placement
15. Common Pitfalls and How to Avoid Them
16. Complete Claude Code Command Reference

---

## 1. Why This Stack: Godot 4 + GDScript + Idle Game

This guide recommends Godot 4 with GDScript as the engine and an idle/incremental game as the genre. This combination was selected after evaluating seven frameworks across five dimensions critical to AI-agent-driven development. Here is why each choice matters.

### Why Godot 4 Over Other Engines

Godot's architecture is uniquely suited for AI coding agents. Every single project file is human-readable text. Scene files (.tscn) use an INI-like format. Resource files (.tres) follow the same pattern. Scripts (.gd) are Python-like with no compilation step. An AI agent can create an entire Godot project from scratch by writing text files alone, with zero editor interaction.

| Dimension | Godot 4 | Unity | Unreal Engine 5 |
|-----------|---------|-------|-----------------|
| Project files | 100% text (.tscn, .tres, .gd) | YAML with auto-gen GUIDs | Binary .uasset / .umap |
| CLI build | `godot --headless --export` | Needs Editor in batchmode | Needs Editor + UAT |
| Build startup time | 2–5 seconds | 30–120 seconds | 60–300 seconds |
| Test framework | GUT (headless CLI) | NUnit (needs Editor) | Gauntlet (needs Editor) |
| LLM training data | High (84% use GDScript) | High (C#) | Medium (C++/BP binary) |
| License | MIT (free forever) | Runtime fee / subscription | 5% royalty after $1M |

### Why Idle/Incremental Games

Idle games sit at the perfect intersection of AI-buildability and ad revenue potential. The entire game state is numbers: production rates, upgrade costs, multipliers, prestige thresholds. There is no physics simulation, no animation timing, no frame-rate-dependent gameplay. Every mechanic can be expressed as a mathematical formula in a JSON config file.

**Ad monetization fit:** Idle games generate approximately 73 rewarded video views per user (industry benchmark), with natural placement points at speed boosts, offline earnings, and prestige bonuses. At US rewarded video eCPMs of $12–20, this translates to strong lifetime revenue per user.

> **KEY INSIGHT:** Idle games eliminate the hardest parts of game development for AI agents (art, physics, animation) while maximizing the parts AI handles best (math, logic, data-driven systems, JSON configuration). The game literally runs itself — the player just makes upgrade decisions.

---

## 2. Prerequisites: Windows Environment Setup

Before Claude Code can operate autonomously, you need a properly configured Windows environment. Every tool below must be accessible from the terminal (PowerShell or WSL2). Claude Code will use these tools via command line — it never opens GUIs.

### Step 1: Install Godot 4.x

- **Download:** Get the Godot 4.3+ Standard build (not .NET/Mono) from godotengine.org
- **Add to PATH:** Add the Godot executable directory to your system PATH so you can call `godot` from any terminal
- **Verify:** Run `godot --version` from PowerShell — it should print the version number
- **Export templates:** Download via `godot --headless --export-templates` or manually from the Godot website. You need Android and iOS templates.

### Step 2: Install Claude Code

- **Install Node.js:** Claude Code requires Node.js 18+. Install from nodejs.org.
- **Install Claude Code:** Run `npm install -g @anthropic-ai/claude-code`
- **Verify:** Run `claude --version` to confirm installation
- **API key:** Set your Anthropic API key via `set ANTHROPIC_API_KEY=sk-ant-...` or configure in the Claude Code settings

### Step 3: Install Android SDK (for Android builds)

- **Android Studio:** Install Android Studio and use SDK Manager to install SDK 33+, Build Tools 33+, and NDK
- **Set environment variables:** `ANDROID_HOME` pointing to your SDK directory
- **ADB:** Ensure `adb` is in PATH for deploying to device/emulator
- **Keystore:** Generate a debug keystore with `keytool -genkey -v -keystore debug.keystore -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000`

### Step 4: Install Git

Install Git for Windows from git-scm.com. Claude Code uses git for version control during development.

### Step 5: Install GUT (Godot Unit Testing)

- **Method:** Clone or download GUT v9.x from GitHub into your project's `addons/gut/` folder
- **Alternative:** Use the Godot Asset Library or add as a git submodule for easy updates

> **WINDOWS-SPECIFIC NOTE:** If you prefer WSL2 for the Linux-like terminal experience, all of these tools work in WSL2 as well. Claude Code runs natively on WSL2 and can call the Linux build of Godot headless. This is actually the recommended setup for the smoothest AI-agent experience, since Godot's headless mode is more battle-tested on Linux.

### Optional but Recommended

- **VS Code:** For reviewing AI-generated code. Install the godot-tools extension for GDScript syntax support.
- **Godot LSP:** Enable the GDScript language server in Godot settings. This gives Claude Code type information and error diagnostics via the LSP protocol.
- **GitHub account:** For hosting the repo and running CI/CD via GitHub Actions.

---

## 3. The CLAUDE.md File: Your AI Agent's Brain

The CLAUDE.md file is the single most important artifact in this workflow. It tells Claude Code everything about your project: architecture rules, naming conventions, file structure, game design constraints, and what to avoid. Every minute invested in CLAUDE.md saves ten minutes correcting AI-generated code.

Place this file in your project root. Claude Code reads it automatically at the start of every session.

### Recommended CLAUDE.md Structure

Below is a battle-tested template. Customize it for your specific game, but keep every section. The specificity matters — vague instructions produce vague code.

```markdown
# CLAUDE.md - Idle Tycoon Game

## Project Overview
An idle/incremental tycoon game built with Godot 4.3 and GDScript.
Monetization: Rewarded video ads (AdMob) + interstitials.
Platforms: Android and iOS.

## Architecture Rules
- All game state lives in GameManager autoload (singleton)
- All economy values come from res://data/balance.json
- Never hardcode numbers in scripts - always reference balance.json
- Scenes use composition: one .tscn per UI panel, combined in main
- Signals for all cross-system communication (never direct refs)

## Build and Test Commands
- Import assets: godot --headless --import --quit
- Run tests: godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit
- Build Android: godot --headless --export-release "Android" build/game.apk
- Build iOS: godot --headless --export-release "iOS" build/game.ipa

## Naming Conventions
- Scripts: snake_case.gd (e.g., upgrade_manager.gd)
- Scenes: snake_case.tscn (e.g., main_game.tscn)
- Signals: past_tense (e.g., currency_changed, upgrade_purchased)
- Constants: UPPER_SNAKE (e.g., MAX_OFFLINE_HOURS)
- Resources: snake_case.tres (e.g., upgrade_data.tres)

## File Structure
- src/autoload/ - Singleton managers (GameManager, AdManager, SaveManager)
- src/scenes/ - .tscn scene files with paired .gd scripts
- src/ui/ - UI components (buttons, panels, popups)
- src/resources/ - .tres custom resources
- data/ - JSON config files (balance.json, upgrades.json)
- tests/ - GUT test files (test_*.gd)

## Game Design Constraints
- Base currency: "coins" (integer, no floats for currency)
- Use Big Number formatting for display (1.5K, 2.3M, 1.1B, etc.)
- Prestige system resets at milestone thresholds
- Offline earnings capped at MAX_OFFLINE_HOURS (default: 8)
- Rewarded ad gives 2x production for 2 minutes
- Interstitial shows every 3rd prestige cycle, min 60s apart

## Common Mistakes to Avoid
- NEVER use Node.get_node() with absolute paths
- NEVER put game logic in _process() without delta time
- NEVER modify balance values outside balance.json
- NEVER forget to disconnect signals in _exit_tree()
- NEVER use await in _ready() for initial setup
```

> **PRO TIP:** Update CLAUDE.md as the project evolves. When Claude Code makes a mistake, add a rule preventing it. When you discover a pattern that works well, document it. Treat CLAUDE.md as a living architectural specification, not a one-time setup file.

---

## 4. Project Structure: Designed for AI Autonomy

This structure is optimized for two things: Claude Code's ability to navigate and modify files, and Godot's headless build system. Every file is text. Every path is predictable. Every system is isolated.

```
my-idle-game/
├── CLAUDE.md                    # AI agent instructions
├── project.godot                 # Godot project config (text INI)
├── export_presets.cfg            # Build target configs (text)
├── .gitignore
├── .github/
│   └── workflows/
│       └── build.yml             # CI/CD pipeline
├── addons/
│   ├── gut/                      # Unit test framework
│   └── admob/                    # AdMob plugin
├── data/
│   ├── balance.json              # All economy values
│   ├── upgrades.json             # Upgrade definitions
│   └── prestige.json             # Prestige tier config
├── src/
│   ├── autoload/
│   │   ├── game_manager.gd      # Global state singleton
│   │   ├── ad_manager.gd        # AdMob wrapper
│   │   ├── save_manager.gd      # JSON save/load
│   │   └── audio_manager.gd     # Sound effects
│   ├── scenes/
│   │   ├── main_game.tscn       # Root scene
│   │   ├── main_game.gd
│   │   ├── upgrade_panel.tscn   # Upgrade purchase UI
│   │   └── prestige_popup.tscn  # Prestige confirmation
│   ├── ui/
│   │   ├── currency_display.gd  # Big Number formatting
│   │   ├── upgrade_button.tscn  # Reusable upgrade row
│   │   └── ad_reward_popup.tscn # "Watch ad" prompt
│   └── systems/
│       ├── economy.gd           # Production/cost math
│       ├── prestige.gd          # Prestige calculations
│       └── offline_earnings.gd  # Offline progress
├── tests/
│   ├── test_economy.gd          # Economy math tests
│   ├── test_prestige.gd         # Prestige logic tests
│   ├── test_save_load.gd        # Serialization tests
│   └── test_ad_triggers.gd      # Ad placement tests
└── build/
    ├── android/                     # Android APK output
    └── ios/                         # iOS project output
```

### Why This Structure Works for AI

- **Flat autoload pattern:** GameManager, AdManager, and SaveManager are globally accessible singletons. Claude Code never needs to figure out node paths or scene tree traversal to access core systems.
- **Data-driven design:** All game balance lives in JSON files under `data/`. Claude Code can tune the entire game economy by editing JSON, without touching any GDScript logic.
- **Isolated test directory:** GUT discovers tests automatically in the `tests/` folder. Claude Code runs all tests with one command and parses the output for pass/fail.
- **Systems separated from scenes:** Pure logic (`economy.gd`, `prestige.gd`) lives in `systems/` with no UI dependencies. These are trivially unit-testable.

---

## 5. The Autonomous Development Loop

This is the core workflow that makes Claude Code effective as a primary developer. The cycle is: write code, validate the project, run tests, read output, fix errors, repeat. Every step happens in the terminal. No GUI ever opens.

### The Five-Step Cycle

**Step 1: Write:** Claude Code creates or modifies .gd, .tscn, .tres, or .json files using its text editing capabilities. It follows CLAUDE.md rules.

**Step 2: Validate:** Run `godot --headless --import --quit` to regenerate the import cache. This catches missing resources, broken scene references, and syntax errors.

**Step 3: Test:** Run `godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` to execute all unit tests. Exit code 0 means all pass.

**Step 4: Analyze:** Claude Code reads terminal output. GUT prints pass/fail for each test with failure messages. Godot prints errors and warnings.

**Step 5: Fix:** Based on the output, Claude Code modifies the relevant files and returns to Step 2. This loop continues until all tests pass.

### Key Commands Reference

| Action | Command | What It Does |
|--------|---------|--------------|
| Validate project | `godot --headless --import --quit` | Imports all assets, checks for errors |
| Run all tests | `godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` | Executes GUT tests, returns exit code |
| Run specific test | `godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/test_economy.gd -gexit` | Runs one test file |
| Build debug APK | `godot --headless --export-debug "Android" build/game.apk` | Builds Android debug build |
| Build release APK | `godot --headless --export-release "Android" build/game.apk` | Builds signed release APK |
| Deploy to device | `adb install -r build/game.apk` | Installs APK on connected device |
| View device logs | `adb logcat -s godot` | Streams Godot runtime logs |

> **CRITICAL: HEADLESS MODE.** The `--headless` flag is what makes this entire workflow possible. It tells Godot to run without creating a window, without initializing a GPU context, and without rendering anything. All logic, imports, and exports execute in pure CPU mode. This is why Godot works for AI agents — Unity and Unreal cannot do this.

---

## 6. Phase 1: Core Idle Game Mechanics

Start here. This phase builds the mathematical engine of the game — the part that runs even when the player isn't looking. Every mechanic is a formula, and every formula lives in balance.json.

### How to Prompt Claude Code

Use task-oriented prompts that reference CLAUDE.md conventions. Be specific about the mathematical model. Here is an example prompt for this phase:

```
Create the core idle game economy system. Follow CLAUDE.md conventions.

1. Create data/balance.json with these values:
   - 5 generators ("Lemonade Stand", "Coffee Cart", "Food Truck",
     "Restaurant", "Hotel Chain")
   - Each generator has: base_cost, cost_multiplier (1.15),
     base_production, production_multiplier
   - Cost formula: base_cost * cost_multiplier ^ owned_count
   - Production formula: base_production * owned_count * prestige_mult

2. Create src/systems/economy.gd with pure functions:
   - calculate_cost(generator_id, owned_count) -> int
   - calculate_production(generator_id, owned_count, prestige) -> float
   - calculate_total_production(all_generators, prestige) -> float

3. Create src/autoload/game_manager.gd as autoload singleton:
   - var coins: int = 0
   - var generators: Dictionary = {} # id -> count
   - func buy_generator(id: String) -> bool
   - signal currency_changed(new_amount)
   - signal generator_purchased(id, new_count)

4. Create tests/test_economy.gd with GUT tests:
   - test_cost_scales_exponentially()
   - test_production_scales_linearly()
   - test_buy_deducts_currency()
   - test_cannot_buy_if_insufficient_funds()

Run tests after creating all files. Fix any failures.
```

### What Claude Code Will Produce

Claude Code will generate four files that form the economic backbone of the game. The balance.json drives everything — you can change the entire feel of the game by editing one JSON file without touching code.

**Expected output:** After the autonomous loop runs, Claude Code should report that all tests pass. If tests fail, it will automatically read the error output, identify the issue, fix the code, and re-run tests until green.

### Prestige System

The prestige system is what gives idle games their long-term retention. When the player resets, they lose all generators but gain a permanent multiplier. Prompt Claude Code with the specific formulas:

```
Add a prestige system. Follow CLAUDE.md conventions.

Prestige formula: prestige_points = floor(sqrt(total_earned / 1e6))
Prestige multiplier: 1 + (prestige_points * 0.1)

Create src/systems/prestige.gd with:
  - calculate_prestige_points(total_earned) -> int
  - calculate_multiplier(prestige_points) -> float
  - can_prestige(total_earned, current_prestige) -> bool
    (requires at least 1 more point than current)

Update GameManager with:
  - var prestige_points: int = 0
  - var total_earned_this_run: int = 0
  - func prestige() -> void  # resets generators, adds prestige
  - signal prestige_completed(new_points, new_multiplier)

Create tests/test_prestige.gd:
  - test_prestige_points_formula()
  - test_multiplier_calculation()
  - test_prestige_resets_generators()
  - test_cannot_prestige_without_gain()

Run all tests (economy + prestige). Fix any failures.
```

---

## 7. Phase 2: UI and Visual Polish

Idle game UI is straightforward: a currency counter at the top, a scrollable list of generators, buy buttons, and a prestige button. Claude Code can build all of this using Godot's built-in Control nodes. No custom art needed for the MVP.

### Scene Composition Strategy

Rather than one massive scene, break the UI into composable pieces. This makes it easier for Claude Code to modify individual components without breaking the whole layout.

| Scene File | Contents | Signals Emitted |
|------------|----------|-----------------|
| main_game.tscn | Root container, references sub-scenes | None (orchestrator) |
| currency_display.tscn | Label showing formatted coin count | None (listens to currency_changed) |
| upgrade_panel.tscn | VBoxContainer of upgrade_button instances | upgrade_requested(id) |
| upgrade_button.tscn | Single upgrade row: name, count, cost, buy btn | buy_pressed(id) |
| prestige_popup.tscn | Confirmation dialog with reward preview | prestige_confirmed |
| ad_reward_popup.tscn | "Watch ad" prompt | ad_watch_requested(type) |

### Big Number Formatting

Players in idle games routinely reach numbers like 1,234,567,890,123. You need a formatting system that converts raw integers to human-readable strings. Prompt Claude Code:

```
Create src/ui/big_number.gd as a static utility:

static func format(n: int) -> String:
  Returns: "1.5K", "2.3M", "1.1B", "4.7T", etc.
  Under 1000: return str(n)
  Suffixes: ["", "K", "M", "B", "T", "Qa", "Qi"]
  Always show 1 decimal place for abbreviated numbers.

Create tests/test_big_number.gd:
  - test_under_thousand() # 999 -> "999"
  - test_thousands()      # 1500 -> "1.5K"
  - test_millions()       # 2300000 -> "2.3M"
  - test_zero()           # 0 -> "0"
```

---

## 8. Phase 3: Ad Monetization with AdMob

This is where the game starts earning money. The godot-admob-plugin provides a GDScript interface to the Google Mobile Ads SDK on both Android and iOS. Claude Code writes the integration layer; you configure the AdMob account details.

### Setup (Human Step)

This is one of the few steps that requires human involvement:

- Create an AdMob account at admob.google.com
- Create an app entry for your game (Android + iOS)
- Create ad unit IDs for: rewarded video, interstitial, and banner
- Download the godot-admob-plugin from the GitHub releases page
- Place the plugin files in `addons/admob/`
- **Add your ad unit IDs to a config:** Create `data/ad_config.json` with your real IDs (and test IDs for development)

### Ad Manager Implementation

Prompt Claude Code to create the ad integration layer:

```
Create src/autoload/ad_manager.gd as an autoload singleton.

Requirements:
- Load ad unit IDs from data/ad_config.json
- Use test IDs when running in debug mode
- Initialize AdMob on _ready() with GDPR consent (UMP)
- Preload rewarded video on startup and after each show
- Expose: show_rewarded(callback: Callable) -> void
- Expose: show_interstitial() -> void
- Track last_interstitial_time for 60-second cooldown
- Emit signals: rewarded_ad_completed, rewarded_ad_failed
- Handle all error cases (no fill, network error, user cancel)

Create tests/test_ad_triggers.gd:
- test_interstitial_cooldown()
- test_rewarded_callback_fires()
- test_debug_uses_test_ids()

Note: Ad tests should mock the AdMob interface since we can't
actually serve ads in headless mode.
```

> **TESTING ADS WITHOUT A DEVICE:** AdMob cannot serve real ads in headless mode. Claude Code should create a mock interface that mimics AdMob's callback behavior (load, show, complete, fail) for testing. The real plugin only activates on actual Android/iOS devices. Use conditional compilation: `if OS.has_feature("mobile"): use real AdMob, else: use mock.`

---

## 9. Phase 4: Save System and Persistence

Idle games must save and restore state perfectly. Players expect to close the app, come back hours later, and see their offline earnings calculated correctly. The save system serializes all game state to JSON and writes it to Godot's user data directory.

### Save Data Architecture

```
Create src/autoload/save_manager.gd as autoload singleton.

Save file path: "user://savegame.json"

Save data structure (JSON):
{
  "version": 1,
  "coins": 123456789,
  "generators": { "lemonade_stand": 25, "coffee_cart": 10 },
  "prestige_points": 3,
  "total_earned_all_time": 9876543210,
  "last_save_timestamp": 1709568000,
  "stats": { "ads_watched": 42, "prestiges_done": 3 }
}

Functions:
- save_game() -> void  # serialize GameManager state to JSON
- load_game() -> bool  # deserialize, return false if no save
- calculate_offline_earnings(last_timestamp) -> int
- Auto-save every 30 seconds via Timer node
- Save on notification(NOTIFICATION_WM_GO_BACK_REQUEST)

Offline earnings formula:
  elapsed = clamp(now - last_save, 0, MAX_OFFLINE_HOURS * 3600)
  earnings = total_production_per_second * elapsed * 0.5
  (50% efficiency while offline, doubled by rewarded ad)

Create tests/test_save_load.gd:
- test_save_and_load_roundtrip()
- test_offline_earnings_calculation()
- test_offline_earnings_cap()
- test_missing_save_returns_false()
- test_version_migration()
```

---

## 10. Phase 5: Testing and Validation

Testing is where the autonomous loop proves its value. Claude Code runs GUT tests after every change, reads failures, and fixes them without human intervention. Well-structured tests are the feedback mechanism that keeps the AI on track.

### Test Categories

| Category | What It Tests | Example Assertion |
|----------|--------------|-------------------|
| Economy math | Cost/production formulas | `assert_eq(calc_cost("gen1", 10), 4046)` |
| Prestige logic | Reset behavior, point calc | `assert_true(can_prestige(1e6, 0))` |
| Save/load | Serialization roundtrip | `assert_eq(loaded.coins, saved.coins)` |
| Offline earnings | Time-based calculation | `assert_between(earnings, 3500, 3600)` |
| Ad triggers | Cooldowns, mock callbacks | `assert_gt(time_since_last, 60)` |
| Big numbers | Display formatting | `assert_eq(format(1500), "1.5K")` |
| Game progression | Can reach prestige in N minutes | `assert_lt(time_to_prestige, 2700)` |

### Progression Testing: The Secret Weapon

The most powerful test category for idle games is automated progression testing. Instead of playing the game manually, Claude Code writes tests that simulate hours of gameplay in seconds:

```gdscript
# tests/test_progression.gd

func test_reach_first_prestige_in_45_minutes():
  var gm = GameManager.new()
  var elapsed = 0.0
  # Simulate optimal play: always buy cheapest available
  while elapsed < 2700.0:  # 45 minutes
    var dt = 1.0  # simulate 1-second ticks
    gm.tick(dt)
    _buy_cheapest_generator(gm)
    elapsed += dt
    if Prestige.can_prestige(gm.total_earned, gm.prestige_points):
      gut.p("Reached prestige at: %d seconds" % elapsed)
      pass_test("Player can prestige within 45 min")
      return
  fail_test("Could not prestige in 45 min - rebalance needed")
```

> **WHY THIS MATTERS:** If this test fails, it means your balance.json values are wrong — the game is too slow or too fast. Claude Code can then adjust balance.json values and re-run the test in a loop until the progression curve feels right. This is automated game balancing, driven by tests, with zero human playtesting.

---

## 11. Phase 6: Building for Mobile

### Android Build (from Windows)

Android builds work directly on Windows with Godot's headless exporter. The entire process is one command after initial setup.

**Step 1: Configure export_presets.cfg**

This text file defines all build settings. Claude Code can create and modify it directly:

```ini
[preset.0]
name="Android"
platform="Android"
custom_features=""
export_filter="all_resources"

[preset.0.options]
package/unique_name="com.yourstudio.idletycoon"
package/name="Idle Tycoon"
version/code=1
version/name="1.0.0"
screen/orientation=1  # Portrait
keystore/debug="debug.keystore"
keystore/debug_user="androiddebugkey"
keystore/debug_password="android"
keystore/release="release.keystore"
keystore/release_user="upload"
keystore/release_password="(your password)"
architectures/arm64-v8a=true
architectures/armeabi-v7a=true
```

**Step 2: Build**

```bash
godot --headless --export-release "Android" build/android/game.apk
```

**Step 3: Test on device**

```bash
adb install -r build/android/game.apk && adb logcat -s godot
```

### iOS Build (from Windows)

iOS builds require a macOS machine for the final Xcode step. From Windows, Claude Code can generate the Xcode project:

```bash
godot --headless --export-release "iOS" build/ios/game.xcodeproj
```

Then transfer the Xcode project to a Mac (or a macOS CI runner) and build with:

```bash
xcodebuild -project game.xcodeproj -scheme game -configuration Release archive
```

> **WINDOWS + iOS WORKFLOW:** The most practical approach for iOS from Windows: use GitHub Actions with a macOS runner. Claude Code pushes code to GitHub, the Actions workflow builds the iOS IPA on Apple silicon, and you download the artifact. You never need to own a Mac for development — only for the final build and signing step in CI.

---

## 12. Phase 7: CI/CD Pipeline

A GitHub Actions pipeline automates every build on every push. Claude Code can create and maintain this pipeline as a YAML file.

```yaml
# .github/workflows/build.yml
name: Build and Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    container: barichello/godot-ci:4.3
    steps:
      - uses: actions/checkout@v4
      - name: Import assets
        run: godot --headless --import --quit
      - name: Run tests
        run: |
          godot --headless \
            -s addons/gut/gut_cmdln.gd \
            -gdir=res://tests \
            -gexit

  build-android:
    needs: test
    runs-on: ubuntu-latest
    container: barichello/godot-ci:4.3
    steps:
      - uses: actions/checkout@v4
      - name: Setup Android SDK
        run: godot --headless --import --quit
      - name: Build APK
        run: |
          mkdir -p build/android
          godot --headless \
            --export-release "Android" \
            build/android/game.apk
      - uses: actions/upload-artifact@v4
        with:
          name: android-build
          path: build/android/game.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Godot
        run: |
          brew install godot
      - name: Build Xcode project
        run: |
          mkdir -p build/ios
          godot --headless \
            --export-release "iOS" \
            build/ios/game.xcodeproj
      - name: Build IPA
        run: |
          xcodebuild -project build/ios/game.xcodeproj \
            -scheme game -configuration Release archive
```

---

## 13. Advanced: Prompt Engineering for Game Dev

How you prompt Claude Code determines the quality and correctness of what it produces. Here are battle-tested patterns for game development with Godot.

### The Three-Part Prompt Pattern

Every effective Claude Code prompt has three parts: context (what exists), task (what to create), and verification (how to confirm it works).

| Part | Purpose | Example |
|------|---------|---------|
| Context | What files exist, what state we're in | "GameManager has coins and generators. Economy.gd has calc_cost()." |
| Task | Specific files to create/modify | "Create upgrade_panel.tscn with a VBoxContainer of upgrade_button instances." |
| Verification | Tests to write and run | "Create test_upgrade_panel.gd. Run all tests. Fix failures." |

### Effective vs. Ineffective Prompts

**Ineffective:** "Add a prestige system to the game."

*Why it fails:* Too vague. Claude Code doesn't know the formula, the trigger conditions, or how it integrates with existing systems.

**Effective:** "Add a prestige system. Formula: prestige_points = floor(sqrt(total_earned / 1e6)). Multiplier: 1 + (points * 0.1). Create prestige.gd in systems/, update GameManager with prestige() function that resets generators but keeps prestige_points. Add test_prestige.gd with tests for formula, reset, and cannot-prestige-without-gain. Run all tests."

*Why it works:* Exact formulas, specific file locations, named functions, concrete test cases, and explicit instruction to run tests.

### The "Fix Loop" Instruction

Always end prompts with an instruction that triggers the autonomous loop:

```
After creating all files:
1. Run: godot --headless --import --quit
2. If errors, fix them and re-run
3. Run: godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit
4. If any test fails, read the output, fix the code, re-run tests
5. Repeat until all tests pass
6. Report: which files were created/modified and test results
```

---

## 14. Monetization Strategy and Ad Placement

The ad placement strategy directly determines your revenue. Idle games have natural "exchange points" where watching an ad gives the player a tangible benefit. Here are the proven placements, ordered by revenue impact.

### Rewarded Video Placements (Primary Revenue)

| Placement | Player Gets | When to Show | Expected Usage |
|-----------|-------------|--------------|----------------|
| Production boost | 2× speed for 2 minutes | Always available button | 3–5 times/session |
| Offline earnings double | 2× offline earnings | On app open after absence | 1 time/session |
| Prestige bonus | 1.5× prestige points | At prestige confirmation | 1 time/prestige |
| Free generator | 1 free unit of best affordable | After 60s idle, popup | 1–2 times/session |
| Skip wait timer | Instant cooldown on ability | When timer active | Variable |

### Interstitial Placements (Secondary Revenue)

- **After every 3rd prestige:** Natural break point where the player expects a pause
- **After milestone achievements:** "Reached 1 Million Coins!" celebration screen
- **Minimum 60-second gap:** Never show interstitials more frequently than once per minute
- **Never during active gameplay:** Only show at natural transition points

### Revenue Expectations

Based on industry benchmarks for idle games with rewarded video focus:

| Metric | Conservative | Average | Optimistic |
|--------|-------------|---------|------------|
| Rewarded views/user (lifetime) | 40 | 73 | 100+ |
| US rewarded eCPM | $10 | $15 | $20+ |
| Revenue per 1K DAU (monthly) | $120 | $250 | $400+ |
| D7 retention | 15% | 20% | 28% |
| Interstitial eCPM | $6 | $10 | $14 |

---

## 15. Common Pitfalls and How to Avoid Them

**Problem:** Claude Code rewrites balance.json with hardcoded values in scripts.
**Solution:** Add this rule to CLAUDE.md: "NEVER hardcode economy values. All numbers come from balance.json. If you find yourself writing a number in GDScript that controls game balance, stop and put it in balance.json instead."

**Problem:** Scene files (.tscn) have circular references.
**Solution:** Follow the composition pattern: scenes reference other scenes via instance() calls, never direct node paths. Add to CLAUDE.md: "Scenes may only reference children they instance. Never use get_node() with paths outside the current scene."

**Problem:** Tests pass but game doesn't work on device.
**Solution:** Write integration tests that simulate real gameplay: buy generators, accumulate currency, prestige, save, load. These catch issues unit tests miss. Also test on device early and often with `adb install`.

**Problem:** AdMob crashes on startup.
**Solution:** The AdMob plugin requires initialization before any ad calls. Ensure ad_manager.gd calls `MobileAds.initialize()` in `_ready()` and waits for the `initialization_complete` callback before loading any ads.

**Problem:** Offline earnings give infinite money.
**Solution:** Always clamp offline time: `elapsed = clamp(now - last_save, 0, MAX_OFFLINE_HOURS * 3600)`. Test edge cases: system clock changed backward, save file from the future, zero elapsed time.

**Problem:** Claude Code creates files in wrong directories.
**Solution:** Be explicit in every prompt about file paths. Start prompts with "Working directory is res://" and name exact paths like "Create src/systems/economy.gd". Put directory rules in CLAUDE.md.

**Problem:** GDScript type errors at runtime.
**Solution:** Enable typed GDScript in CLAUDE.md: "Always use type hints. `var coins: int = 0`, not `var coins = 0`. Function signatures must include return types: `func calc(x: int) -> float`."

**Problem:** Game balance is wrong (too fast/slow).
**Solution:** Write progression tests that simulate optimal play. If `test_reach_prestige_in_45_minutes()` fails, the balance is off. Let Claude Code adjust balance.json values and re-run until it passes.

---

## 16. Complete Claude Code Command Reference

This is a quick-reference for every command you'll use in this workflow. Copy these into your CLAUDE.md or use them as prompt suffixes.

### Godot Headless Commands

| Command | Purpose |
|---------|---------|
| `godot --version` | Print Godot version |
| `godot --headless --import --quit` | Import all assets and validate project |
| `godot --headless --export-debug "Android" out.apk` | Build debug Android APK |
| `godot --headless --export-release "Android" out.apk` | Build release Android APK |
| `godot --headless --export-release "iOS" out.xcodeproj` | Export iOS Xcode project |
| `godot --headless -s script.gd` | Run a standalone GDScript |
| `godot --headless --check-only` | Validate GDScript syntax without running |

### GUT Test Commands

| Command | Purpose |
|---------|---------|
| `godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` | Run all tests |
| `... -gtest=res://tests/test_economy.gd -gexit` | Run specific test file |
| `... -gselect=test_cost_scales -gexit` | Run specific test method |
| `... -glog=3 -gexit` | Verbose logging (levels 0–3) |

### Android/ADB Commands

| Command | Purpose |
|---------|---------|
| `adb devices` | List connected devices/emulators |
| `adb install -r game.apk` | Install APK (replace existing) |
| `adb logcat -s godot` | Stream Godot logs from device |
| `adb logcat -s godot \| grep ERROR` | Filter for errors only |
| `adb shell am start -n com.you.game/.GodotApp` | Launch the game |

### Git Commands for Claude Code

| Command | Purpose |
|---------|---------|
| `git init && git add -A && git commit -m "init"` | Initialize project repo |
| `git add -A && git commit -m "description"` | Commit after each phase |
| `git diff --stat` | Review what changed |
| `git log --oneline -10` | Recent commit history |

---

> **Ready to Build.** Open your terminal, navigate to your project directory, and run: `claude`. Then paste your first Phase 1 prompt. Claude Code takes it from there.