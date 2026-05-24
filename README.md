# dontlose

> **Don't lose to the clock.**

A macOS app for **timed practice rounds** — system-design interviews, production-bug response drills, and focused work sessions — wrapped in real, world-class animations.

The clock is the only opponent. Stay sharp. Don't lose the round.

## Modes

| Mode | Steps | Default |
|---|---|---|
| **Interview** (system design) | Scope · High-level design · Deep dive · Wrap & scale | 45 min |
| **Prod Bug** | Triage · Mitigate · Root cause · Postmortem | 30 min |
| **Common Task** | Plan · Execute · Review | 25 min |

## Animation themes

- 🥊 **Box Fight** — ring, crowd, fighters, POW! on step complete, bell on transitions
- ⚽ **World Cup 26** — stadium with real crowd + random flags, your team vs opponent (country selector), goal horn on step complete
- ▫️ **Minimal** — bar + digital step marker only

All themes share a single LED-style digital step marker and a draining timer bar.

## Tech

- SwiftUI shell (macOS 14+)
- SpriteKit for full-stage scenes
- Rive for HUD / step marker / timer (state-machine driven)
- AVAudioEngine for sound

## Status

Pre-alpha. Design doc lives in `docs/superpowers/specs/`.

## License

TBD.
