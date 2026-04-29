---
name: Nobi-Nobi Note
colors:
  surface: '#fff8f5'
  surface-dim: '#e5d7d1'
  surface-bright: '#fff8f5'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#fff1ea'
  surface-container: '#f9ebe4'
  surface-container-high: '#f3e5df'
  surface-container-highest: '#ede0d9'
  on-surface: '#211a16'
  on-surface-variant: '#54433d'
  inverse-surface: '#362f2b'
  inverse-on-surface: '#fceee7'
  outline: '#87736c'
  outline-variant: '#dac1b9'
  surface-tint: '#94492b'
  primary: '#94492b'
  on-primary: '#ffffff'
  primary-container: '#ff9e7a'
  on-primary-container: '#783317'
  inverse-primary: '#ffb59b'
  secondary: '#366853'
  on-secondary: '#ffffff'
  secondary-container: '#b8eed3'
  on-secondary-container: '#3c6e58'
  tertiary: '#765b06'
  on-tertiary: '#ffffff'
  tertiary-container: '#d6b35b'
  on-tertiary-container: '#5b4500'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbcf'
  primary-fixed-dim: '#ffb59b'
  on-primary-fixed: '#380d00'
  on-primary-fixed-variant: '#763216'
  secondary-fixed: '#b8eed3'
  secondary-fixed-dim: '#9dd2b8'
  on-secondary-fixed: '#002115'
  on-secondary-fixed-variant: '#1c4f3c'
  tertiary-fixed: '#ffdf96'
  tertiary-fixed-dim: '#e7c269'
  on-tertiary-fixed: '#251a00'
  on-tertiary-fixed-variant: '#594400'
  background: '#fff8f5'
  on-background: '#211a16'
  surface-variant: '#ede0d9'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
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
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 20px
  lg: 32px
  xl: 48px
  margin-mobile: 20px
  gutter: 16px
---

## Brand & Style

The brand personality for the parenting app is rooted in the concept of "Nobi-Nobi"—a Japanese expression for growing up freely, stretchily, and without constraint. This design system emphasizes a **Modern-Tactile** aesthetic. It blends the cleanliness of modern digital interfaces with soft, organic touches that evoke the feeling of a cherished physical baby journal or scrapbook.

The visual language is designed to be a "digital companion" for parents, reducing cognitive load during stressful moments while celebrating the joy of child development. The interface uses generous white space to create a sense of calm and clarity, paired with subtle, paper-like textures and rounded forms that feel safe and approachable.

## Colors

The palette is anchored by a warm, sun-kissed coral that radiates energy and affection. This is balanced by a soft sage green to represent growth and a mellow yellow for moments of celebration and milestones.

- **Primary (#FF9E7A):** Used for main actions, active states, and brand-critical elements. It is warm and inviting without being overly aggressive.
- **Secondary (#86BAA1):** A calming sage green used for health tracking, sleep logs, and nature-related growth markers.
- **Tertiary (#FFD97D):** A soft gold used for highlights, rewards, and achievements.
- **Neutral (#5C534E):** A deep, warm charcoal used for typography instead of pure black, maintaining the "gentle" brand voice.
- **Surface:** Use a soft off-white (#FAF9F6) for backgrounds to reduce eye strain and provide a "paper" feel.

## Typography

This design system utilizes **Plus Jakarta Sans** for its friendly, geometric clarity and soft terminals, which align perfectly with the "Nobi-Nobi" spirit. 

To maintain a clean and modern look, typography should be used with ample line height to ensure readability for tired parents. Use the Bold and Semi-Bold weights sparingly for hierarchy in headers, while keeping body text in Regular weight to maintain the gentle aesthetic. For Japanese character rendering, ensure the font stacks prioritize system sans-serifs that share the same optical weight and rounded characteristics.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for mobile-first interactions. It uses an 8px base rhythm to ensure consistent alignment across all components.

- **Margins:** A standard 20px side margin is used on mobile to prevent content from feeling cramped against the edges of the device.
- **Internal Padding:** Use 12px or 16px for internal card padding to maintain a spacious, breathable feel.
- **Vertical Rhythm:** Group related items with 8px or 12px gaps, and separate distinct sections with 32px or 48px to clearly define the content hierarchy without needing heavy dividers.

## Elevation & Depth

Visual hierarchy is achieved through **Tonal Layers** and **Ambient Shadows**. This design system avoids harsh, dark shadows in favor of soft, diffused blurs that suggest a light source from directly above.

- **Surface Tiers:** Use subtle shifts in background color (e.g., a slightly warmer cream for the background and pure white for foreground cards) to create depth.
- **Shadows:** When elevation is required for interactivity (like floating action buttons or active cards), use a primary-tinted shadow (e.g., #FF9E7A with 15% opacity, 12px blur, 4px Y-offset) to keep the interface feeling vibrant and warm.
- **Glassmorphism:** Use subtle backdrop blurs (10-15px) on sticky navigation bars to provide context of the content scrolling underneath without cluttering the view.

## Shapes

The shape language of this design system is defined by high roundedness, conveying safety and friendliness. 

- **Cards & Containers:** Use a default radius of 1rem (16px) for major containers and cards to give them a "soft-touch" feel.
- **Interactive Elements:** Buttons and tags should utilize a pill-shape (fully rounded corners) to make them look "tappable" and approachable.
- **Visual Accents:** Incorporate organic, slightly imperfect circular shapes for decorative background elements to reinforce the "growth" and "nature" themes of child development.

## Components

Components are designed to feel tactile and easy to interact with one-handed.

- **Buttons:** Primary buttons are pill-shaped and use the #FF9E7A accent color. Secondary buttons use a soft-tinted background (5-10% opacity of the primary color) rather than an outline, keeping the UI soft.
- **Chips & Tags:** Use these for categorizing activities (e.g., "Milk," "Sleep," "Play"). They should be pill-shaped with small, playful icons.
- **Cards:** Use a white surface with a very soft ambient shadow and 16px rounded corners. Headers within cards should be clearly defined with `headline-sm`.
- **Input Fields:** Instead of harsh borders, use a soft, filled background style (#F3F2EE) with 12px corner radius. On focus, the field should animate to a thin 2px primary color border.
- **Growth Milestones:** A custom progress bar component with a rounded "seed" or "sprout" icon at the end of the bar to visualize the child's development progress.
- **Daily Log Items:** List items should use left-aligned icons in soft circles, with a subtle vertical line connecting items in a timeline view to represent the continuity of daily life.