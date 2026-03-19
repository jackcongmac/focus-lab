# Focus Lab – Product Requirement Document (MVP)

## 1. Overview

Focus Lab is a game-based iOS application designed to train executive function skills in children aged 5–7 through structured, low-stimulation gameplay.

The MVP focuses on a single core mechanic:
Sequential task execution (step-by-step memory and action).

---

## 2. Target Users

### Primary Users
- Children aged 5–7

### Secondary Users
- Parents concerned about:
  - Attention span
  - Task completion
  - Early ADHD-related behaviors
  - Learning readiness

---

## 3. Problem Statement

Many children struggle with:
- Following multi-step instructions
- Maintaining focus during tasks
- Completing tasks in correct order

Existing apps are either:
- Academic-focused (ABC, math)
- Entertainment-focused (games)

There is a gap in:
👉 Structured executive function training through play

---

## 4. Product Goals

### Primary Goal
Train children's ability to:
- Remember steps
- Execute tasks in order
- Stay focused during short tasks

### Secondary Goal
Provide parents with simple insights into:
- Completion rate
- Accuracy
- Engagement

---

## 5. Core Gameplay Loop

1. Show task steps (2–5 steps)
2. Hide instructions
3. Player performs actions in correct order
4. System evaluates input:
   - Correct → proceed
   - Incorrect → soft reset
5. Level completion → success feedback → next level

---

## 6. Core Features (MVP)

### 6.1 Step Mission Game

- Display steps using visual + text cues
- Steps shown for ~2 seconds
- Steps hidden before interaction
- Player taps items in sequence
- Immediate feedback on input

---

### 6.2 Difficulty System

| Level | Steps | Difficulty |
|------|------|------------|
| L1 | 2 steps | No distraction |
| L2 | 3 steps | Low distraction |
| L3 | 3–4 steps | Medium |

---

### 6.3 Feedback System

- Correct tap:
  - Subtle visual confirmation
- Wrong tap:
  - Highlight error
  - Show "Try again"
  - Reset sequence
- Success:
  - “Great job”
  - Next button

---

### 6.4 Parent Progress (Basic)

Display:
- Missions completed
- Accuracy (%)
- Total play time

Storage:
- Local only (UserDefaults)

---

## 7. UX / Design Principles

- Low stimulation (no overwhelming animations)
- Clean and minimal UI
- Predictable interaction patterns
- Clear cause-and-effect feedback
- Friendly but not overly childish

---

## 8. Technical Scope

### Platform
- iOS (iPhone + iPad)

### Tech Stack
- SwiftUI
- MVVM architecture

### Data
- Local storage only
- No backend

---

## 9. Non-Goals (MVP)

- No login/account system
- No cloud sync
- No subscription (Phase 2)
- No AI personalization
- No multiple game modes
- No sound design (Phase 1)

---

## 10. Success Metrics

### Engagement
- Average session > 3 minutes
- Level completion rate > 60%

### Retention
- Day 1 retention > 35%

### Parent Value
- Parent view usage > 30%

---

## 11. Future Expansion (Post-MVP)

- More levels and difficulty scaling
- Adaptive difficulty system
- Subscription model
- Sound and reward system
- Executive function categories:
  - Memory
  - Inhibition
  - Planning

---

## 12. Key Differentiation

Focus Lab is not:
- A general learning app
- A casual kids game

Focus Lab is:
👉 A structured executive function training system delivered through gameplay

---

## 13. Development Phase

### Phase 1 (Current)
- Single gameplay mode
- 3–5 levels
- Local data tracking
- Internal testing

### Phase 2
- Subscription testing
- More content
- Parent insights upgrade
