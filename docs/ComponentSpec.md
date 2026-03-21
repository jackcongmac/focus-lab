# Focus Lab – Component Specification (Core)

This document defines exact UI behavior and structure for key components.

Use together with:
- VisualSystem_Core.md (rules)
- GameSpec.md (logic)

---

# 1. Instruction

## Purpose
Primary guidance for the child. Must be the most noticeable element.

## Layout
- Position: centered, above grid
- Spacing:
  - top → dots: 12–16pt
  - instruction → grid: 16–20pt

## Typography
- Size: ~20–24pt
- Weight: Medium / Semibold
- Color: primary text (dark gray)

## Behavior
- Updates instantly on level change
- No animation on change (avoid distraction)

## Rules
- Must always be readable within 1 second
- Must not compete with feedback or decoration
- Max 1 line preferred

---

# 2. Grid (Tile Container)

## Structure
- 2 × 2 fixed layout
- Always 4 tiles
- Positions never change across levels

## Spacing
- Tile size: ~120–160pt (iPad responsive)
- Gap: 16–20pt

## Background
- Neutral (light gray)
- No visual noise

---

# 3. Tile (PlayItemButton)

## Purpose
Interactive target for selection

## Layout
- Shape centered inside tile
- Padding: ~24–32pt inside tile

## Visual
- Background: white
- Corner radius: large (20–32pt)
- No strong border

---

## States

### Idle
- No animation
- Stable

---

### On Touch Down (IMPORTANT)
- Immediate feedback (<100ms)
- Slight scale down (0.98)
- Sound should trigger here (not on release)

---

### On Correct

- Scale up: ~1.08–1.12
- Duration: <200ms
- Optional:
  - soft glow OR slight border emphasis
- Allowed:
  - subtle spring (no bounce exaggeration)

---

### On Error

- Gentle horizontal shake (small amplitude)
- OR subtle color pulse

Rules:
- Must not feel like punishment
- Must reset quickly (<400ms)

---

# 4. Feedback (Text)

## Purpose
Secondary confirmation (not primary attention)

## Placement
- Centered above grid OR slightly overlapping grid area
- Must be near action area

## Typography
- Slightly smaller than instruction
- Medium weight

---

## Timing

- Fade in: ~0.15–0.2s
- Visible: ~0.5–0.7s
- Fade out: ~0.2s

Total: ~1s

---

## Rules
- Must be readable but not dominant
- Must not appear far from action area
- Avoid top-of-screen placement

---

# 5. Orb (CalmOrbView)

## Purpose
Subtle emotional / focus indicator

---

## Placement (IMPORTANT)

Allowed:
- Below instruction
- OR inside grid area (preferred long term)

Not allowed:
- Between dots and instruction

---

## Behavior

### Idle
- Slow breathing scale (very subtle)
- ~0.98 ↔ 1.02

---

### On Correct
- Slight scale up (~1.05–1.08)
- Opacity increase
- Fast settle (<200ms)

---

## Rules
- Must not draw attention away from task
- Must be peripheral, not focal

---

# 6. Progress Dots

## Purpose
Session progress indicator

---

## Layout
- Top of screen
- Small size (6–8pt)

---

## Behavior
- Active dot: filled
- Others: low opacity

---

## Animation
- Simple fade / scale
- No spring required

---

# 7. Transitions (Level → Level)

## Current Rule
DO NOT:

- Remove tiles
- Rebuild layout
- Full screen transitions

---

## Instead

- Keep tile containers
- Animate content inside tiles

---

## Allowed

- Crossfade shapes
- Subtle scale swap

---

## Goal

Continuity > spectacle

---

# 8. Sound (Future Hook)

## Principles

- Immediate (on touch down)
- Short (<300ms)
- Soft, non-sharp

---

## Types

- Tap
- Correct
- Error

---

## Rules

- Must reinforce action timing
- Must not lag behind interaction

---

# 9. Global Rules

- Response must feel instant
- No animation should block interaction
- No element should compete with the task
- Everything must feel predictable

---

# 10. Definition of “Good”

A correct implementation should feel:

- Calm
- Clear
- Responsive
- Predictable
- Slightly rewarding (not exciting)
