import { useState } from 'react';
import { BrowserRouter } from 'react-router-dom';
import AppRoutes from './routes';
import { GamesProvider } from './context/GamesContext';
import { AuthProvider } from './context/AuthContext';
import LoadingScreen from './components/LoadingScreen';
import BackToTop from './components/BackToTop';

function App() {
  const [loading, setLoading] = useState(true);

  return (
    <BrowserRouter>
      <AuthProvider>
        <GamesProvider>
          {loading && <LoadingScreen onComplete={() => setLoading(false)} />}
          <AppRoutes />
          <BackToTop />
        </GamesProvider>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
