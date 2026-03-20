import { BrowserRouter } from 'react-router-dom';
import AppRoutes from './routes/private';
import { GamesProvider } from './context/GamesContext';

function App() {
  return (
    <BrowserRouter>
      <GamesProvider>
        <AppRoutes />
      </GamesProvider>
    </BrowserRouter>
  );
}

export default App;
