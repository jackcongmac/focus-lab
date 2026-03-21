# Focus Lab – Theme & Content System (MVP)

This document defines the content structure for Focus Lab.

Goal:
- Introduce variety without increasing cognitive load
- Maintain consistent gameplay structure
- Enable scalable content expansion

---

# 1. Core Principle

Gameplay must remain identical across all content.

- 4 tiles only
- Same level structure (Levels 1–10)
- Same interaction rules
- Same feedback behavior

Only the content inside tiles changes

---

# 2. Content Hierarchy

Content is organized into three layers:

## 2.1 Theme (Top Level)

A Theme represents a category of objects.

Examples:
- Shapes
- Animals
- Vehicles

---

## 2.2 Set (Within Theme)

Each Theme contains one or more Sets.

A Set is a group of exactly 4 items used in gameplay.

Example:

Animals Theme:
- Set B1: bird, fish, rabbit, turtle

---

## 2.3 Session Flow

Each session uses:

- One Theme
- One Set
- Levels 1–10 progression

After Level 10:
- Move to next Theme or Set
- Restart at Level 1

---

# 3. Color Mapping (Critical Rule)

Color mapping must remain consistent across all Themes and Sets.

- Slot 1 → Blue
- Slot 2 → Red
- Slot 3 → Green
- Slot 4 → Yellow

Example:

Shapes:
- Blue circle
- Red square
- Green triangle
- Yellow star

Animals:
- Blue bird
- Red fish
- Green rabbit
- Yellow turtle

Rules:
- Never remap colors to different slots
- Never change color roles between sets
- Color is part of the learning system

---

# 4. MVP Themes and Sets

## 4.1 Theme: Shapes

### Set A1 (Core)
- circle
- square
- triangle
- star

Purpose:
- Baseline training
- Pure shape recognition

---

## 4.2 Theme: Animals

### Set B1 (Core)
- bird
- fish
- rabbit
- turtle

Selection Criteria:
- Clear silhouette
- High visual distinction
- Child-friendly and neutral

---

## 4.3 Theme: Vehicles

### Set C1 (Core)
- car
- bus
- train
- airplane

Selection Criteria:
- Distinct shapes
- Easy to recognize at small size
- High engagement for some users

---

# 5. Item Design Requirements

All items must follow these rules:

## 5.1 Visual Clarity

- Recognizable within 1 second
- Strong silhouette
- Minimal detail
- No reliance on small features

---

## 5.2 Consistency

- Same visual style across themes
- Flat design
- No gradients or complex textures

---

## 5.3 Differentiation

- Items within a set must be clearly distinguishable
- Avoid similar shapes in the same set

---

## 5.4 Language Simplicity

Instruction must be simple:

Examples:
- "Tap the blue bird"
- "Tap the red bus"

Avoid:
- Complex names
- Multi-word technical terms

---

# 6. Voice Integration

Voice instructions must follow:

- Speak instruction immediately on level start
- Match text exactly
- Clear pronunciation
- Slight pacing for children

Examples:
- "Tap... the blue bird"
- "Tap... the green triangle"

---

# 7. Content Rotation

After completing all 10 levels:

- Switch to next Theme or Set
- Restart from Level 1
- Maintain same gameplay structure

Optional:
- Brief inline message (e.g. "Animals")

Do NOT:
- Add overlay screens
- Change layout

---

# 8. Future Expansion (Not MVP)

Future Themes may include:

- Food
- Objects (household)
- Characters / Dolls
- Nature

Future Sets:
- Multiple sets per theme
- Gradual content expansion

Rules remain:
- 4 items per set
- Same color mapping
- Same gameplay

---

# 9. Definition of Success

A correct implementation should:

- Feel familiar across all themes
- Introduce novelty through content only
- Avoid confusion when switching sets
- Maintain continuous flow

---

# 10. Summary

Focus Lab scales through:

- Content variety (Themes & Sets)
- Not gameplay complexity

Same system,
Different content,
Consistent experience.
