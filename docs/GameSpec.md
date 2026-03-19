# Focus Lab – Game Interaction Specification (MVP)

## 1. Design Goal

Create a calm, clear, and predictable interaction experience that helps children:

- Understand what to do
- Stay focused
- Feel safe when making mistakes
- Feel rewarded when succeeding

---

## 2. Core Interaction Principles

### 2.1 Low Stimulation
- No fast flashing
- No sudden movement
- No loud or aggressive feedback

### 2.2 Predictability
- Same structure every level
- Same feedback pattern
- No unexpected UI jumps

### 2.3 Clarity
- Always know:
  - What to do
  - What just happened
  - What happens next

---

## 3. Game Phases & Timing

### Phase 1: Instruction (Showing Steps)

Duration: **2.0 seconds**

UI:
- Title: “Watch the steps”
- Show steps as vertical cards

Animation:
- Fade in (0.2s)
- Static display

Exit:
- Fade out (0.3s)

---

### Phase 2: Ready State

Duration: **0.3 seconds**

UI:
- Text: “Your turn”

Purpose:
- Transition buffer (important for cognition)

---

### Phase 3: Interaction (Main Gameplay)

UI:
- 2x2 grid of items
- Top shows:
  - Step X of Y

---

## 4. Tap Interaction

### 4.1 Tap Feedback (Immediate)

On tap:

- Scale down: 1.0 → 0.95 (0.08s)
- Scale back: 0.95 → 1.0 (0.12s)

Purpose:
- Confirm touch
- Increase responsiveness

---

### 4.2 Correct Tap Feedback

When correct:

- Subtle highlight (green border or glow)
- Duration: 0.2s

Then:
- Move to next step

---

### 4.3 Wrong Tap Feedback

When incorrect:

- Item flashes:
  - Slight red overlay OR border
- Duration: 0.25s

UI message:
- “Let’s try again”

Delay:
- 0.6–0.8s before reset

Reset behavior:
- Step index resets to 0
- Stay in same level

Important:
- No punishment feeling
- No loud or harsh feedback

---

## 5. Step Progress Feedback

UI (top area):

- “Step 1 of 3”
- Updates immediately after correct input

Optional:
- Subtle progress dots (future)

---

## 6. Success State

Trigger:
- All steps completed

UI:

- Text: “Great job!”
- Calm success visual

Animation:

- Fade in success message (0.3s)
- Optional soft scale (1.0 → 1.05 → 1.0)

Buttons:

- Primary: “Next”
- Secondary: “Retry”

---

## 7. Layout Guidelines

### 7.1 Spacing

- Use generous spacing
- Avoid clutter
- Minimum padding: 16–24pt

---

### 7.2 Grid

- 2 columns
- Equal spacing
- Large touch targets

Item size:
- Minimum height: 120–140pt

---

### 7.3 Colors

- Background: soft neutral
- Item background: light gray
- Accent colors:
  - Red
  - Blue
  - Yellow
  - Green

Avoid:
- Neon colors
- High contrast flashing

---

## 8. Typography

- Title: bold, clear
- Instructions: simple, short
- Avoid long sentences

Examples:
- “Watch the steps”
- “Your turn”
- “Great job!”

---

## 9. Motion Rules

Allowed:
- Fade
- Scale
- Soft highlight

Not allowed:
- Shake
- Bounce aggressively
- Fast repeated animations

---

## 10. Error Philosophy

Error should feel like:
👉 Guidance, not failure

Do:
- Soft message
- Reset calmly

Avoid:
- “Wrong!”
- Loud signals
- Frustration loops

---

## 11. Success Philosophy

Success should feel:
👉 Calmly rewarding

Do:
- Positive language
- Light visual feedback

Avoid:
- Over-reward (confetti explosion etc.)

---

## 12. MVP Scope Reminder

This spec applies to:

- Step Mission gameplay only
- No sound yet
- No advanced animation
- No reward system

---

## 13. Future Enhancements (Not Now)

- Sound design
- Haptics
- Adaptive timing
- More expressive feedback
