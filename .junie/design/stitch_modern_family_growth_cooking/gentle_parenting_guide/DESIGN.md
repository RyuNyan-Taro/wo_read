---
name: Gentle Parenting Guide
colors:
  surface: '#f4fafd'
  surface-dim: '#d4dbdd'
  surface-bright: '#f4fafd'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eef5f7'
  surface-container: '#e8eff1'
  surface-container-high: '#e2e9ec'
  surface-container-highest: '#dde4e6'
  on-surface: '#161d1f'
  on-surface-variant: '#54433d'
  inverse-surface: '#2b3234'
  inverse-on-surface: '#ebf2f4'
  outline: '#87736c'
  outline-variant: '#dac1b9'
  surface-tint: '#94492b'
  primary: '#94492b'
  on-primary: '#ffffff'
  primary-container: '#ff9e7a'
  on-primary-container: '#783317'
  inverse-primary: '#ffb59b'
  secondary: '#28695c'
  on-secondary: '#ffffff'
  secondary-container: '#acecdc'
  on-secondary-container: '#2d6d60'
  tertiary: '#416182'
  on-tertiary: '#ffffff'
  tertiary-container: '#9abae0'
  on-tertiary-container: '#2a4a6a'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbcf'
  primary-fixed-dim: '#ffb59b'
  on-primary-fixed: '#380d00'
  on-primary-fixed-variant: '#763216'
  secondary-fixed: '#afefdf'
  secondary-fixed-dim: '#93d3c3'
  on-secondary-fixed: '#00201a'
  on-secondary-fixed-variant: '#045044'
  tertiary-fixed: '#d0e4ff'
  tertiary-fixed-dim: '#a9c9f0'
  on-tertiary-fixed: '#001d35'
  on-tertiary-fixed-variant: '#284969'
  background: '#f4fafd'
  on-background: '#161d1f'
  surface-variant: '#dde4e6'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  margin-page: 24px
  gutter-card: 16px
  stack-sm: 12px
  stack-md: 24px
---

## Brand & Style

This design system is built on the philosophy of "Nurturing Clarity." It is designed to feel like a supportive companion for parents, balancing the emotional warmth of childcare with the functional precision required for tracking growth and managing household tasks. 

The aesthetic is **Modern/Minimal** with a **Tactile** twist. We use generous white space to reduce cognitive load, paired with soft, organic shapes that feel safe and approachable. The emotional response should be one of "calm capability"—providing the user with high-contrast, easy-to-read information without sacrificing the tender, pastel-toned joy associated with early childhood.

## Colors

The palette utilizes "Functional Pastels." While the colors are soft and warm, they are applied with sufficient saturation to meet accessibility standards for older users. 

- **Primary (Warm Peach):** Used for main actions and "Growth Records" to evoke warmth and skin-to-skin connection.
- **Secondary (Mint Green):** Reserved for "Cooking" and "Recipes," symbolizing fresh ingredients and health.
- **Tertiary (Soft Blue):** Used for technical data, utility icons, and sleep tracking.
- **Neutral:** A deep charcoal instead of pure black is used for all text to ensure high legibility while remaining "soft" on the eyes.
- **Background:** A warm-tinted off-white prevents the screen glare common with pure white backgrounds.

## Typography

This design system prioritizes readability for a multi-generational audience. We use **Plus Jakarta Sans** for its friendly, rounded terminals and high x-height, which ensures clarity even at smaller sizes.

The standard body size is increased to **18px** (`body-lg`) to accommodate users who may have declining eyesight or are viewing the screen while multi-tasking with a child. Line heights are intentionally generous to prevent text lines from crowding, creating a breezy, easy-to-scan reading experience. Headlines use a heavy weight to create a clear visual hierarchy.

## Layout & Spacing

The design system utilizes a **Fluid Grid** with an 8px base unit. To ensure the interface is "thumb-friendly" for parents who are likely using the device one-handed, we implement wide 24px outer margins. 

The vertical rhythm is spacious. Containers and sections are separated by large gaps (`stack-md`) to clearly delineate different types of information. On the Home screen, a "Focus Row" layout is used where the primary features occupy larger card footprints to make them the primary tap targets.

## Elevation & Depth

To maintain the "Modern & Warm" aesthetic, this design system avoids harsh, dark shadows. Instead, it employs **Tonal Layers** and **Ambient Tinted Shadows**.

- **Surface Level:** The main background is the lowest layer.
- **Card Level:** Cards use a very subtle, diffused shadow tinted with the primary color (e.g., a soft peach glow for growth cards) to indicate interactivity.
- **Interactive Level:** Active buttons use a slightly deeper shadow and a 2px offset to appear "lifted" and physically pressable.
- **Modal Level:** Large overlays use a backdrop blur (glassmorphism) with 20% opacity to maintain context of the screen behind them.

## Shapes

The shape language is defined by **Softened Geometrics**. There are no sharp corners in this design system, as sharp angles can subconsciously trigger a sense of "danger" or "strictness" which conflicts with the parenting theme.

- **Cards & Containers:** Use `rounded-lg` (16px) for a sturdy but friendly appearance.
- **Buttons:** Use `rounded-xl` (24px) or full pill-shapes to maximize the "tapable" look and distinguish them from informational cards.
- **Icons:** Icons should feature rounded caps and corners, maintaining a consistent stroke weight of 2px for high visibility.

## Components

### 1. Feature Cards (Home Screen)
The 'Growth Records' (成長記録) and 'Cooking' (料理) components are designed as **Large Hero Cards**. 
- They feature a split-layout: a large, friendly illustrative icon on the left and a bold title with a secondary "Last updated" label on the right.
- The 'Growth' card uses a Peach background with 10% opacity, while 'Cooking' uses a Mint background with 10% opacity.

### 2. Primary Buttons
Buttons are pill-shaped and high-contrast. The primary action button uses a solid Peach fill with White text. The target area is at least 56px in height to ensure ease of use for older users or those in a hurry.

### 3. Data Entry Fields
Input fields are "Warm Outlined"—using a 2px border in a soft grey that turns Peach when active. Labels are always floating above the field (never disappearing as placeholder text) to ensure the user never loses track of what they are typing.

### 4. Progress Chips
Small, rounded-pill indicators used within the Growth Records to show percentiles or completion status. These use the Tertiary Blue to signify a "metric" or "status" rather than a primary action.

### 5. Bottom Navigation
A simplified dock with 4 clear icons. Labels are always present below the icons in `label-lg` to ensure no one has to guess the meaning of a symbol.