---
name: Indonesian Commerce Mobile
colors:
  surface: '#f9f9ff'
  surface-dim: '#d3daef'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f3ff'
  surface-container: '#e9edff'
  surface-container-high: '#e1e8fd'
  surface-container-highest: '#dce2f7'
  on-surface: '#141b2b'
  on-surface-variant: '#434656'
  inverse-surface: '#293040'
  inverse-on-surface: '#edf0ff'
  outline: '#737688'
  outline-variant: '#c3c5d9'
  surface-tint: '#004ee8'
  primary: '#0042c7'
  on-primary: '#ffffff'
  primary-container: '#0056fe'
  on-primary-container: '#e3e7ff'
  inverse-primary: '#b6c4ff'
  secondary: '#465ba0'
  on-secondary: '#ffffff'
  secondary-container: '#9fb3ff'
  on-secondary-container: '#2e4387'
  tertiary: '#972600'
  on-tertiary: '#ffffff'
  tertiary-container: '#c13402'
  on-tertiary-container: '#ffe2da'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dce1ff'
  primary-fixed-dim: '#b6c4ff'
  on-primary-fixed: '#001550'
  on-primary-fixed-variant: '#003ab2'
  secondary-fixed: '#dce1ff'
  secondary-fixed-dim: '#b6c4ff'
  on-secondary-fixed: '#00164f'
  on-secondary-fixed-variant: '#2d4286'
  tertiary-fixed: '#ffdbd1'
  tertiary-fixed-dim: '#ffb5a0'
  on-tertiary-fixed: '#3b0900'
  on-tertiary-fixed-variant: '#872100'
  background: '#f9f9ff'
  on-background: '#141b2b'
  surface-variant: '#dce2f7'
  brand-navy: '#0F286C'
  brand-primary: '#0056FE'
  brand-primary-pressed: '#0047D1'
  brand-subtle: '#EBF2FF'
  bg-canvas: '#F7F8FA'
  bg-surface: '#FFFFFF'
  bg-sunken: '#EFF1F4'
  text-primary: '#111827'
  text-secondary: '#4B5563'
  text-tertiary: '#6B7280'
  text-placeholder: '#9CA3AF'
  text-on-brand: '#FFFFFF'
  border-subtle: '#E5E7EB'
  border-default: '#D1D5DB'
  border-strong: '#9CA3AF'
  danger: '#FB132D'
  danger-subtle: '#FFECEE'
  success: '#109553'
  success-subtle: '#E8F8EF'
  warning: '#F59E0B'
  warning-subtle: '#FFF6E5'
  signature-black: '#101014'
  signature-gold: '#C9A227'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-lg:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  headline-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  title-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
  caption:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '400'
    lineHeight: 14px
  price-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
  price-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 22px
  price-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

# DESIGN.md — Xpedia (Buyer Mobile)

Product: Xpedia — the buyer-facing marketplace app for Indonesia.
Platform: Mobile first, 390 × 844 dp. Target implementation is Flutter.
UI language: Bahasa Indonesia.
Tone: familiar, fast, trustworthy. A buyer used to Indonesian marketplaces must understand it instantly. Differentiation comes from trust and transparency, never from an unfamiliar checkout.

## 1. Color
- brand-navy: #0F286C (Wallet balance card, dark headers)
- brand-primary: #0056FE (Primary buttons, links, active tab, selected state)
- brand-primary-pressed: #0047D1
- brand-subtle: #EBF2FF (Selected chip, info banner, promo background)
- bg-canvas: #F7F8FA
- bg-surface: #FFFFFF
- bg-sunken: #EFF1F4
- text-primary: #111827
- text-secondary: #4B5563
- text-tertiary: #6B7280
- text-placeholder: #9CA3AF
- text-on-brand: #FFFFFF
- border-subtle: #E5E7EB
- border-default: #D1D5DB
- border-strong: #9CA3AF
- danger: #FB132D / subtle #FFECEE
- success: #109553 / subtle #E8F8EF
- warning: #F59E0B / subtle #FFF6E5
- Xpedia Signature: Black #101014 with gold #C9A227.

## 2. Typography
Inter only.
Heading/XL 24/32 w700 · Heading/L 20/28 w600 · Heading/M 18/26 w600 · Title/L 16/24 w600 · Title/M 14/20 w600 · Body/L 16/24 w400 · Body/M 14/20 w400 · Body/S 12/18 w400 · Label/L 14/20 w500 · Label/M 12/16 w500 · Label/S 11/14 w500 · Caption 11/14 w400 · Price/L 18/24 w700 · Price/M 16/22 w700 · Price/S 14/20 w600

## 3. Spacing, radius, size
Spacing: 0 2 4 6 8 12 16 20 24 32 40 48 64. Screen padding: 16. Radius: 8 default. Control height: 36 44 52. App bar: 56. Bottom nav: 64. Minimum touch target: 48.

## 4. Non-negotiable product rules
1. Search has no Filter button, no Sort control, and no recommendation selector.
2. One search bar handles products, brands, and store names.
3. The Xpedia logo is the Home control.
4. All payment goes through Xpedia Wallet only. No external cards/VA at checkout.
5. Every payment requires 6-digit PIN or biometrics.
6. 5 Bottom navigation items: Beranda, Wishlist, Pesanan Saya, Chat, My Xpedia.
