# Focus Lab – Visual System

## 1. Design Principles

- Calm, minimal, and functional  
- No decorative elements without purpose  
- Reduce cognitive load at all times  
- Visual clarity over expressiveness  
- Consistency across all content sets  

---

## 2. Layout System

- Fixed 2×2 grid (4 tiles per level)
- Tile position is persistent across levels
- Layout does NOT change between levels
- Only content inside tiles changes

Principle:
Structure is constant, content is dynamic

---

## 3. Color System

### 3.1 Training Colors (Semantic)

Used for recognition tasks.

- Blue
- Red
- Green
- Yellow

Rules:
- High contrast
- Stable mapping (color meaning should not change)
- Avoid gradients or complex shading

---

### 3.2 Neutral UI Colors

Used for interface only.

- Background: soft neutral
- Tile: white or light neutral
- Text: dark gray / near black

Rules:
- Must NOT compete with training colors
- Always secondary to task content

---

## 4. Shape & Object System

### 4.1 Core Principle

The system does NOT limit to 4 shapes.

Instead:

- The app uses an expandable Item Library
- Each level selects 4 items from the library
- Only 4 items are displayed at any time

---

### 4.2 Item Requirements

All items (shapes or objects) must follow:

- Clear silhouette
- Easily distinguishable at small size
- No internal noise or unnecessary detail
- Recognizable within <1 second

---

### 4.3 Visual Style Rules

All items must be:

- Flat (no gradients)
- Minimal detail
- Solid fill or very simple stroke
- High contrast against background
- Consistent visual weight

---

### 4.4 Shape Language (Base Set Example)

Initial set (MVP):

- Circle
- Square
- Triangle
- Star

These define the baseline style, but are NOT exclusive.

---

### 4.5 Future Expansion

Additional items may include:

- Pentagon
- Hexagon
- Oval
- Diamond
- Heart
- Cross
- Vehicles (car, bus, etc.)
- Animals
- Objects

Rule:
New items must conform to the same visual language.

---

## 5. Content System (Critical)

- Each level displays exactly 4 items
- Items are selected from a larger pool
- Different levels may use different item sets

Principle:
Content can expand infinitely, but presentation remains constrained

---

## 6. Motion System

### Principles

- Calm
- Short
- Predictable
- Non-distracting

---

### Allowed Animations

- Fade (opacity)
- Scale (subtle, 0.95–1.0)
- Small stagger between elements (optional)

---

### Timing

- Feedback: 0.8–1.2s visibility
- Transitions: <300ms
- No blocking animations

---

### Not Allowed

- Bounce
- Spring-heavy motion
- Rotation
- Large movement across screen

---

## 7. Feedback Visibility

- Feedback text must be clearly readable
- Slightly larger than secondary text
- Positioned near task area (not detached)
- Must NOT feel like decoration

---

## 8. Identity (Lightweight)

- Minimal branding
- Simple mark (grid / dots / structure-based)
- No heavy visual branding elements

Principle:
Identity comes from consistency, not decoration

---

## 9. Future Compatibility

This system must support:

- Multiple themes (vehicles, animals, etc.)
- Progressive difficulty
- Different item libraries
- Parent-facing analytics (non-visual layer)

---

## 10. Core Philosophy

Focus Lab is not a visual playground.

It is a structured attention environment.

Every visual decision must support:
- clarity
- focus
- continuity
