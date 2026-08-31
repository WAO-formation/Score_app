import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Unit tests only — pure logic in services/hooks, mocked Firestore. Rules
// tests live under src/test/rules and run separately (see
// vitest.rules.config.js) since they need a live Firestore emulator, not a
// jsdom environment.
export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.js'],
    exclude: ['**/node_modules/**', '**/dist/**', 'src/test/rules/**'],
  },
});
