# Focus Lab – Visual System (Core)

This document defines the practical visual system for MVP development.

Goal:
- Support focus training (ages 3–7)
- Reduce cognitive load
- Ensure clarity, consistency, and scalability

This is a Core System, not the full brand expression.

---

## 1. Design Principles

- Clarity over decoration  
- Calm over stimulation  
- Consistency over variation  
- Function over style  

Every visual decision must support:
- understanding
- attention
- continuity

---

## 2. Layout System

- Fixed 2×2 grid (4 tiles)
- Tile positions are persistent across levels
- Layout does NOT change during gameplay
- Only content inside tiles updates

Principle:
Structure is stable, content changes

---

## 3. Attention Hierarchy (Critical)

1. Instruction (primary)
2. Interactive items (grid)
3. Feedback (secondary)
4. Background (passive)

Rules:
- Nothing competes with instruction or target items
- Feedback must be visible, but not dominant
- Background must stay neutral

---

## 4. Color System

### 4.1 Training Colors (Highest Priority)

Used for gameplay logic.

- Blue
- Red
- Green
- Yellow

Rules:
- Must remain high contrast
- Must NOT be modified (no gradients, no tint shifts)
- Must always be visually dominant over UI colors

---

### 4.2 UI Colors (Secondary)

Used for interface only.

- Background: light neutral
- Tile: white
- Text: dark gray

Rules:
- Must NOT compete with training colors
- Keep low contrast and minimal variation

---

## 5. Item System (Expandable)

The system supports unlimited item types, but:

- Each level shows exactly 4 items
- Items are selected from a larger library

---

### 5.1 Item Requirements

All items must:

- Be recognizable within 1 second
- Have a clear silhouette
- Avoid unnecessary detail
- Work well at small sizes

---

### 5.2 Visual Style

- Flat (no gradients)
- Minimal detail
- Solid fill preferred
- High contrast against background
- Consistent visual weight

---

### 5.3 Base Set (MVP)

- Circle
- Square
- Triangle
- Star

Note:
This is a starting set, not a limitation.

---

### 5.4 Future Expansion

Examples:

- Pentagon, Hexagon
- Vehicles
- Animals
- Objects

Rule:
All future items must follow the same visual style.

---

## 6. Motion System

### Principles

- Calm
- Fast
- Predictable
- Non-distracting

---

### Allowed

- Fade (opacity)
- Subtle scale (0.95–1.0)
- Short transitions (<300ms)
- Subtle spring for positive feedback only (correct tap, step advance)
  - Must be fast (response ≤ 0.3s)
  - Must not repeat or loop
  - Must not distract from the task

---

### Not Allowed

- Bounce
- Looping spring
- Rotation
- Large movement

---

## 7. Feedback System

Feedback is functional, not decorative.

### Requirements

- Must be readable within 1 second
- Slightly larger than secondary text
- Positioned near the task area
- Must not be missed

---

### Timing

- Correct: ~0.8–1.0s
- Error: ~0.9s
- Completion: ~1.2–1.5s

---

## 8. Interaction Principles

- Immediate response (<100ms perceived)
- No waiting for animations
- Continuous flow between levels
- No disruptive screen transitions

---

## 9. Boundaries & Separation

Avoid strong visual separation.

Preferred:
- spacing
- background tone differences

Allowed when necessary:
- very subtle borders (low opacity)

Rule:
Clarity > visual purity

---

## 10. Identity (Minimal)

- No heavy branding
- No decorative UI
- Identity comes from:
  - consistency
  - spacing
  - motion
  - simplicity

---

## 11. Core Philosophy

Focus Lab is not a game interface.

It is a structured attention environment.

Design should feel:
- stable
- predictable
- quiet
- responsive
