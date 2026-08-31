import { defineConfig } from 'vite';

// Firestore security-rules tests — run against a live emulator via
// `npm run test:rules` (wraps this in `firebase emulators:exec`). Plain
// node environment: no DOM, no React, just the rules-unit-testing SDK.
export default defineConfig({
  test: {
    environment: 'node',
    include: ['src/test/rules/**/*.test.js'],
    testTimeout: 20000,
    hookTimeout: 20000,
  },
});
