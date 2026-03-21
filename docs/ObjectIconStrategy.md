# FocusLab – Object Icon Strategy

## 1. Goal

Define a scalable icon system for all content in FocusLab.

The system must:
- Support fast visual recognition (≤ 1 second)
- Maintain consistency across all themes
- Minimize cognitive load
- Scale without redesign

---

## 2. Core Principles

Clarity > Completeness  
Consistency > Variety  
Recognition > Realism  

All icon decisions must prioritize:
- Immediate understanding
- Low cognitive effort
- Stable visual language

---

## 3. Icon Source Strategy

### 3.1 Tier 1 — SF Symbols (Default)

Use SF Symbols when:

- Clear silhouette
- Easily distinguishable in a 2×2 grid
- Exists in current iOS runtime
- Matches flat, minimal visual style

Examples:
- circle
- square
- triangle
- star
- airplane
- car (acceptable)

---

### 3.2 Tier 2 — Custom Icons (When Needed)

Use custom icons when ANY of the following applies:

- Symbol does not exist (e.g. helicopter)
- Shape ambiguity is high (e.g. bus vs train)
- Recognition takes longer than 1 second
- Icons are too visually similar within a set
- Style inconsistency across items

---

## 4. Visual Requirements

All icons (SF or custom) must follow:

### 4.1 Silhouette First
- Recognizable by outline alone
- Must work without color

### 4.2 Minimal Detail
- No small features
- No textures
- No gradients

### 4.3 Consistent Visual Weight
- Similar stroke/fill weight across items
- No icon should feel heavier or lighter

### 4.4 Small Size Compatibility
- Must remain clear at tile size (~80–120pt)

---

## 5. Set Composition Rules

Each set contains exactly 4 items.

### 5.1 Differentiation Rule (Critical)

Within a set:
- Items must be visually distinct
- Avoid similar silhouettes

Bad example:
- car / bus / train / van

Good example:
- car / airplane / boat / bicycle

---

### 5.2 Cognitive Load Rule

Only one type of difficulty per level:

- Shape difficulty OR
- Color difficulty

Never both at the same time.

---

## 6. Validation Checklist

Every icon must pass all tests:

### 6.1 1-Second Recognition Test
Can a child identify it within 1 second?

### 6.2 Pair Confusion Test
When compared with a similar item, is it still distinguishable?

### 6.3 Grid Test (2×2)
When all 4 items are shown together:
- Any confusion?
- Any visual overlap?

### 6.4 No-Text Test
Remove all labels:
- Is it still understandable?

---

## 7. Anti-Patterns (Do NOT)

- Do NOT add text labels to compensate unclear icons
- Do NOT mix different illustration styles
- Do NOT use realistic or detailed images
- Do NOT rely on reading ability
- Do NOT use icons that differ only by small details

---

## 8. Expansion Strategy

When adding new themes:

1. Start with SF Symbols
2. Apply validation checklist
3. If failed → create custom icons
4. Ensure style consistency with existing system

---

## 9. Example: Vehicles (Current)

Set:
- car
- bus
- train
- airplane

Evaluation:
- car → OK
- airplane → OK
- bus → potential ambiguity
- train → potential ambiguity

Action:
- Keep for MVP
- Replace with custom icons only if real user confusion is observed

---

## 10. Key Principle

Do NOT fix icon problems with text.

Fix icon problems with better icons.
