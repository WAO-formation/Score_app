import { BrowserRouter } from 'react-router-dom';
import AppRoutes from './routes/private';
import { GamesProvider } from './context/GamesContext';
import { AuthProvider } from './context/AuthContext';

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <GamesProvider>
          <AppRoutes />
        </GamesProvider>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
