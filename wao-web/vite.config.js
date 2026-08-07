import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [
    react({
      babel: {
        plugins: [['babel-plugin-react-compiler']],
      },
    }),
    tailwindcss(),
  ],
  build: {
    outDir: 'dist',
    sourcemap: false,
    chunkSizeWarningLimit: 600,
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('node_modules/react-dom') || id.includes('node_modules/react/')) return 'react';
          if (id.includes('node_modules/react-router') || id.includes('node_modules/@remix-run')) return 'router';
          if (id.includes('node_modules/firebase')) return 'firebase';
          if (id.includes('node_modules/gsap')) return 'gsap';
          if (id.includes('node_modules/lucide-react')) return 'lucide';
          if (id.includes('node_modules/@fullcalendar')) return 'calendar';
        },
      },
    },
  },
});
