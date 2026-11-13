import js from '@eslint/js'
import globals from 'globals'
import reactHooks from 'eslint-plugin-react-hooks'
import reactRefresh from 'eslint-plugin-react-refresh'
import { defineConfig, globalIgnores } from 'eslint/config'

export default defineConfig([
  // .history is a local-history editor backup directory (timestamped
  // snapshots of every save, e.g. SideNav_20260208101808.jsx) — not real
  // source. Left unignored, its hundreds of half-edited snapshots drowned
  // out every real finding under src/ (96% of lint output was from here).
  globalIgnores(['dist', '.history']),
  {
    files: ['**/*.{js,jsx}'],
    extends: [
      js.configs.recommended,
      reactHooks.configs.flat.recommended,
      reactRefresh.configs.vite,
    ],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
      parserOptions: {
        ecmaVersion: 'latest',
        ecmaFeatures: { jsx: true },
        sourceType: 'module',
      },
    },
    rules: {
      'no-unused-vars': ['error', { varsIgnorePattern: '^[A-Z_]' }],
    },
  },
  {
    // Test/config files run under Node (Vitest, firebase-tools helper
    // scripts), not the browser — they need process/__dirname etc, which
    // the browser globals set above deliberately doesn't include.
    files: ['**/*.test.js', 'src/test/**/*.js', 'vitest*.config.js', 'scripts/**/*.js'],
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
    },
  },
])
