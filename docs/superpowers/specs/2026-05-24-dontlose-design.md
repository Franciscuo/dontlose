# dontlose — Design Spec

**Date:** 2026-05-24
**Status:** Draft (awaiting user sign-off before plan + implementation)
**Author:** Claude (Opus 4.7) with franlopz10
**Tagline:** *Don't lose to the clock.*

## 1. Problem

People who interview for system-design roles, who carry pagers, and who want to practice deep work all face the same problem: **timed thinking is a skill that decays without rehearsal**. Generic timers (Pomodoro, stopwatch apps) treat all time the same. They don't enforce a structured process and they don't make the pressure visceral.

A real interview has phases. A real production incident has phases. A real deep-work session benefits from a plan/execute/review split. A timer that just counts down doesn't teach the *shape* of these activities — it just measures them.

**dontlose** is a macOS app that runs **timed practice rounds** with a process baked in for each mode, and dresses the timer up in real, world-class animation so the pressure feels like a sport, not a chore. The clock is the only opponent. The user wins by completing all steps before the buzzer.

## 2. Users & goals

| User | Primary goal |
|---|---|
| Engineer prepping for a system-design interview | Run 4-step interview rounds, build the habit of clarifying scope before designing |
| On-call engineer drilling for incidents | Practice the triage → mitigate → root-cause → postmortem rhythm under time pressure |
| Anyone doing focused work | A 3-step plan/execute/review timer that's more engaging than a vanilla Pomodoro |

Non-users: people looking for a stopwatch, a task manager, a calendar, or a productivity dashboard. dontlose is for **single timed sessions**, nothing more.

## 3. Modes

All modes share the same engine: a total time, divided into N steps with a percentage split. Default totals and splits can be overridden per session and saved as presets.

### Interview mode (4 steps, default 45 min)

| # | Step | % | Default min @45 |
|---|---|---|---|
| 1 | Requirements & Scope | 15 % | 7 min |
| 2 | High-level design | 35 % | 16 min |
| 3 | Deep dive | 35 % | 16 min |
| 4 | Wrap & scale | 15 % | 6 min |

Reflects the canonical 4-phase system-design interview: clarify functional/non-functional requirements, propose a high-level architecture, drill into 1–2 components with tradeoffs, then close on scale/failure modes.

### Prod Bug mode (4 steps, default 30 min)

| # | Step | % | Default min @30 |
|---|---|---|---|
| 1 | Triage | 10 % | 3 min |
| 2 | Mitigate / stop the bleeding | 40 % | 12 min |
| 3 | Root cause | 30 % | 9 min |
| 4 | Postmortem note | 20 % | 6 min |

The bias toward mitigation (40 %) is intentional — in a real incident, restoring service comes before understanding it.

### Common Task mode (3 steps, default 25 min)

| # | Step | % | Default min @25 |
|---|---|---|---|
| 1 | Plan | 10 % | 2.5 min |
| 2 | Execute | 75 % | 19 min |
| 3 | Review & notes | 15 % | 3.5 min |

A 25-min Pomodoro split with explicit plan-before-execute and capture-after.

## 4. Animation themes

Three themes ship in v1. The theme is orthogonal to the mode — any theme can run any mode, since both express "N steps over T minutes."

### 🥊 Box Fight

- **Stage:** boxing ring with crowd silhouettes, two corner-colored fighters, swinging bell, draining timer bar
- **Idle (in-step):** fighters bob and throw rhythmic jabs; crowd cheers; bell still
- **Step transition:** bell rings hard, fighters reset to corners, round counter advances, brief "ROUND N" overlay
- **Step complete (mid-step manual advance):** glove thud + POW! starburst
- **Session complete:** KO sequence — one fighter goes down, crowd roar, "WINNER" overlay
- **Timer expiring (last 10 %):** crowd intensifies, bell trembles, screen edge pulses red

### ⚽ World Cup 26

- **Stage:** stadium with skyline backdrop, crowd of people (varied skin/shirt colors), ~12 % hold small flags (host nation biased, sprinkled with rest of the world), green pitch with center circle + penalty boxes, two players in user-selected national kits, ball passed between them in an arc
- **Idle:** players bob, ball cycles between them, crowd waves
- **Step transition:** referee whistle, scoreboard segment advances, brief "GROUP STAGE" / etc. overlay
- **Step complete:** goal horn + goal celebration (player slides, confetti in user's flag colors)
- **Session complete:** final whistle, trophy lift, anthem snippet
- **Timer expiring:** crowd chant rises, scoreboard flashes

### ▫️ Minimal

- **Stage:** dark background, the digital step marker on top, the draining timer bar on bottom, nothing else
- **Step transition:** marker segment slides, soft chime
- **Step complete:** brief checkmark pulse
- **Session complete:** "Round complete." text, single bell
- For users who want the structure without the spectacle

### Shared HUD across all themes

- **Digital step marker** (LED-scoreboard styled): one segment per step, shows `✓ done` / `▶ active (pulsing)` / `pending`, with the step label
- **Timer bar:** drains across the bottom, color shifts green → yellow → red as time runs out
- **Step label + remaining:** "STEP 2 / 4 · HIGH-LEVEL DESIGN — 8:24 remaining"

## 5. Country selector (World Cup only)

A setup-screen widget that appears when the World Cup theme is picked. Two slots — "Your team" and "Opponent" — each picked from a grid of country tiles (flag + 3-letter code). A 🎲 Random button picks for the user. v1 ship list: COL, FRA, BRA, ARG, GER, ESP, ITA, UK, JPN, MEX, USA, CAN, NGA, IND, KEN, PER (16 tiles, all FIFA-eligible). Choice drives player kit colors, confetti colors, and crowd flag bias (host-nation gets more flags in the stands).

Boxing theme has an analogous slot pair (corner color picker: red / blue / green / yellow) — same widget, different domain.

## 6. Sound design

Each theme has a sound pack with the same five slots. Global mute and per-pack volume in settings.

| Slot | Boxing | World Cup | Minimal |
|---|---|---|---|
| Ambient loop | Crowd hum | Stadium chant | (none) |
| Step start | Bell ding | Referee whistle | Soft chime |
| Step complete | Glove thud | Goal horn | Checkmark tick |
| 30 s / 10 s warning | Cornerman shout / bell tremble | Crowd surge / chant peak | Subtle tone / tick |
| Session complete | KO bell + crowd roar | Final whistle + anthem | Single bell |

All sound is AVAudioEngine, files bundled in the .app (no network calls). v1 uses CC0 / royalty-free assets (freesound.org, OpenGameArt); replace with custom commissions in v2 if the project warrants it.

## 7. Tech stack

| Layer | Choice | Why |
|---|---|---|
| Platform | macOS 14+ native | User asked for a real macOS app, not Electron |
| Shell + setup screens | SwiftUI | First-class macOS UI, dark/light mode for free |
| Full-stage scenes | SpriteKit | Apple-native 2D engine, sprite sheets first-class, integrates with SwiftUI via `SpriteView` |
| HUD + step marker + timer bar | Rive | State-machine driven, ~60 FPS, binds animation state directly to app state (tick → all elements react from one source of truth), 50–80 % smaller files than Lottie |
| One-shot decorative flourishes (intro splash, mode icons) | Lottie | Free packs available on lottiefiles.com to ship day-one and replace later |
| Sound | AVAudioEngine | Bundled assets, no network, mixable per-pack |
| Persistence (v1) | UserDefaults | Settings, last preset, mute state. Migrate to SwiftData in v2 if we need session history |

**Distribution:** signed `.app` (Developer ID), no notarization needed for personal/sideload use; can be added later. Target binary ≤ 50 MB.

**Repository:** https://github.com/Franciscuo/dontlose

## 8. Architecture (high level)

```
┌─────────────────────────────────────────────────────────────┐
│                       SwiftUI App Shell                     │
│  ┌────────────┐  ┌───────────────┐  ┌────────────────────┐  │
│  │ SetupView  │→ │ SessionView   │→ │ SessionCompleteView│  │
│  └────────────┘  └───────────────┘  └────────────────────┘  │
└────────┬────────────────┬────────────────────┬──────────────┘
         │                │                    │
         ▼                ▼                    ▼
   ┌──────────┐    ┌──────────────┐    ┌──────────────┐
   │ Settings │    │  SessionVM   │    │   Results    │
   │ (UD)     │    │ (ObservableO)│    │  (in-mem)    │
   └──────────┘    └──────┬───────┘    └──────────────┘
                          │ ticks, step events
                          ▼
            ┌──────────────────────────────┐
            │  Theme Engine (protocol)     │
            ├──────────────────────────────┤
            │  + BoxingTheme  (SpriteKit)  │
            │  + WorldCupTheme(SpriteKit)  │
            │  + MinimalTheme (SwiftUI)    │
            └──────┬──────────────┬────────┘
                   │              │
                   ▼              ▼
            ┌──────────┐    ┌──────────┐
            │ HUD/Rive │    │  Sound   │
            │ (shared) │    │ (AVAudio)│
            └──────────┘    └──────────┘
```

**Theme protocol** (Swift):
```swift
protocol Theme {
    var id: String { get }
    var setupAccessory: AnyView { get } // country picker for WC, corner picker for boxing, nil for minimal
    func makeStageView(state: SessionState) -> AnyView
    func soundPack: SoundPack { get }
}
```

`SessionState` is the single source of truth: current step index, time remaining in step, time remaining total, last event (`stepStarted` / `stepCompleted` / `warningFired` / `sessionComplete`). The HUD, the SpriteKit scene, and the sound engine all subscribe to it.

## 9. Acceptance criteria (v1)

### Setup flow
- AC1: App opens to a setup screen showing Mode / Total Time / Theme pickers + (Country selector if Theme=WorldCup, Corner picker if Theme=Boxing) + Start button
- AC2: Changing Mode updates the default Total Time and the visible step labels in real time
- AC3: A "Save as preset" button persists the current setup; presets appear as quick-pick tiles on subsequent launches
- AC4: A "Random" button picks team + opponent / corner colors for the user

### Session flow
- AC5: Hitting Start transitions to a full-window session view rendering the selected theme's stage at ≥ 30 FPS on M-series Macs (target 60 FPS)
- AC6: The digital step marker shows all N steps, with `✓ done` / `▶ active` / `pending` styling
- AC7: A timer bar drains continuously across the bottom; color shifts green → yellow → red as time runs out
- AC8: Step transitions (either auto on timer expiry, or manual via Skip-step) fire (a) the theme's transition visual, (b) the theme's step-start sound (with the step-complete cue layered on first if the transition was manual), and (c) advance the digital step marker — all driven from a single state change so visuals + audio + HUD can never desync
- AC9: 30-second and 10-second warnings (per step) fire the theme's warning sound and trigger a warning visual
- AC10: Pause / Resume / Skip-step / Restart controls are accessible via on-screen buttons AND keyboard shortcuts (space / →  / R)
- AC11: Session-complete state shows the theme's session-complete animation and a summary line ("4 / 4 steps · finished 0:32 under time")

### Persistence + offline
- AC12: All sound assets bundled in the .app; the app runs with networking disabled
- AC13: Settings, last preset, master mute, and per-pack volumes persist between launches via UserDefaults
- AC14: Window respects macOS Dark/Light mode

### Quality
- AC15: Signed `.app` ≤ 50 MB
- AC16: No CPU usage above 10 % when idle on the setup screen; no memory growth across 10 consecutive sessions
- AC17: All themes pass a manual 45-min run-through without visual glitches, audio dropouts, or state desync

## 10. Out of scope for v1

- Session history / stats / charts
- iCloud sync of presets
- Custom user-defined sound packs
- Custom step labels per session (only mode defaults in v1)
- Screen recording / export
- Multiplayer / shared sessions
- App Store distribution + notarization (sideload only)
- iOS / iPadOS build
- A fourth theme (we've discussed but deferred — easy to add later given the Theme protocol)

## 11. Risks & open questions

| Risk | Mitigation |
|---|---|
| Rive's macOS runtime maturity | Verify on day 1 with a hello-world; fall back to SwiftUI canvas if blocked |
| World Cup trademarks | We use only generic terminology ("World Cup 26", "stadium") and our own art; no FIFA logos, no official mascots, no copyrighted anthems |
| Sound asset licensing | Stick to CC0/CC-BY on first import; track attributions in `CREDITS.md` |
| SpriteKit + SwiftUI integration friction | `SpriteView` is supported but lifecycle/coordinator quirks exist — verify scene reload on theme switch works cleanly |

## 12. Build sequence (high level — full plan to be written by writing-plans skill)

1. SwiftUI app shell + SessionViewModel + persistent Settings
2. Theme protocol + Minimal theme (proves the engine end-to-end without the spectacle)
3. Boxing theme (SpriteKit ring + characters + sound pack)
4. World Cup theme (SpriteKit stadium + crowd + country selector + sound pack)
5. Shared Rive HUD (step marker + timer bar)
6. Polish pass + signing + AC verification

Five of these (1–5) are largely independent and well-suited to parallel `feature-dev:feature-dev` agents once the plan is locked.

---

*End of design spec. Awaiting user sign-off before invoking writing-plans.*
