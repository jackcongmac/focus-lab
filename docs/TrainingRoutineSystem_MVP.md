# FocusLab – Training Routine System (MVP)

## 1. Goal

Define a simple, structured training system for FocusLab that:

- Encourages daily practice habits
- Supports parent-guided routines
- Adapts over time with recommendations
- Keeps implementation simple (MVP)

---

## 2. Core Philosophy

FocusLab provides structure and recommendations.  
Parents retain control over the routine.

---

## 3. System Overview

The system is built around Practice Sessions.

A complete loop:

Recommendation  
→ Parent selects / adjusts  
→ Session runs (time-based)  
→ Session ends  
→ Analysis generated  
→ Recommendation updated  

---

## 4. Practice Session

### 4.1 Definition

A session is time-based, not level-based.

1 session = X minutes of continuous practice

---

### 4.2 Default Settings (MVP)

- Default duration: 5 minutes
- Optional durations:
  - 3 min
  - 5 min
  - 8 min
  - 10 min
  - 15 min

---

### 4.3 Session Flow

Start Session  
→ Run levels continuously  
→ Timer reaches duration  
→ Finish current level  
→ Session Complete  
→ Show summary  

---

### 4.4 Content Behavior

- Session uses one selected theme
- Levels progress from easy → harder
- When reaching max level:
  - loop or continue progression (MVP: simple loop)

---

## 5. Timer & Control

### 5.1 Timer Behavior

- Displays remaining time (e.g. "4:12 left")
- Runs only during active play

---

### 5.2 Pause

When paused:

- Session timer stops
- All hint timers stop
- Audio stops
- No delayed events continue

Pause = full system freeze

---

### 5.3 Resume

- Continue from exact same state
- No reset

---

### 5.4 End Session

User (parent) can:

- End early

---

### 5.5 End Conditions

1. Completed  
   - Timer reached  
   - Current level finished  

2. Ended Early  
   - User manually ends  

3. Abandoned (future)  
   - Paused but not resumed  

---

## 6. Session Result (Analysis – MVP)

Each session records:

- duration practiced
- levels completed
- errors count
- accuracy (simple)
- theme used
- end type (completed / early)

---

## 7. Recommendation System (MVP)

### 7.1 Default Recommendation

- Sessions per day: 3
- Duration: 5 minutes

---

### 7.2 Adjustment Strategy (Rule-based)

System updates recommendation based on consistency.

Example progression:

5 min → 8 min → 10 min → 15 min

---

### 7.3 Important Rule

Adjust duration, NOT frequency.

- Frequency = parent-controlled
- Duration = system-recommended

---

## 8. Parent Control

Parent can control:

- Sessions per day
- Session duration
- Enabled themes
- Pause / resume / end session

---

### 8.1 Recommendation vs Control

| Type | Controlled by |
|------|--------------|
| Duration suggestion | System |
| Session count | Parent |
| Theme selection | Parent |

---

## 9. UI Integration

### Gameplay Screen

Must include:

- Timer (subtle, non-intrusive)
- Pause button
- Continue / End options

---

### Parent Area (MVP)

- Session history (list)
- Total sessions
- Simple stats (duration / completion)
- Theme enable / disable
- Duration selection

---

## 10. Design Principles

- Calm (no pressure / no aggressive countdown)
- Stable (no layout jump)
- Predictable (clear session boundaries)
- Encouraging (positive reinforcement)

---

## 11. Out of Scope (MVP)

- AI-driven personalization
- Complex analytics dashboards
- Multi-user accounts
- Cloud sync

---

## 12. Key Insight

Levels define difficulty.  
Sessions define training.
