import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { SplitText } from 'gsap/SplitText';

gsap.registerPlugin(ScrollTrigger, SplitText);

/**
 * Fade + rise with stagger
 */
export function fadeUp(targets, vars = {}) {
  gsap.set(targets, { opacity: 0, y: 48 });
  return gsap.to(targets, {
    opacity: 1,
    y: 0,
    duration: 0.8,
    ease: 'power3.out',
    stagger: 0.1,
    ...vars,
  });
}

/**
 * Clip-path reveal (bottom → top wipe)
 */
export function clipReveal(targets, vars = {}) {
  gsap.set(targets, { clipPath: 'inset(100% 0% 0% 0%)', opacity: 1 });
  return gsap.to(targets, {
    clipPath: 'inset(0% 0% 0% 0%)',
    duration: 0.9,
    ease: 'power4.out',
    stagger: 0.12,
    ...vars,
  });
}

/**
 * Slide in from left
 */
export function slideLeft(targets, vars = {}) {
  gsap.set(targets, { opacity: 0, x: -60 });
  return gsap.to(targets, {
    opacity: 1,
    x: 0,
    duration: 0.9,
    ease: 'power3.out',
    ...vars,
  });
}

/**
 * Slide in from right
 */
export function slideRight(targets, vars = {}) {
  gsap.set(targets, { opacity: 0, x: 60 });
  return gsap.to(targets, {
    opacity: 1,
    x: 0,
    duration: 0.9,
    ease: 'power3.out',
    ...vars,
  });
}

/**
 * Scale + fade pop
 */
export function scalePop(targets, vars = {}) {
  gsap.set(targets, { opacity: 0, scale: 0.88 });
  return gsap.to(targets, {
    opacity: 1,
    scale: 1,
    duration: 0.7,
    ease: 'back.out(1.4)',
    stagger: 0.08,
    ...vars,
  });
}

/**
 * Build a ScrollTrigger-driven timeline
 */
export function buildScrollTL(trigger, start = 'top 78%') {
  return gsap.timeline({
    defaults: { ease: 'power3.out' },
    scrollTrigger: { trigger, start },
  });
}
