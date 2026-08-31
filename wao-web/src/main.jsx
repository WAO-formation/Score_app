import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'

// No <StrictMode> here: its dev-only mount->unmount->remount double-invoke
// of effects reliably corrupts the Firebase JS SDK v12 Firestore
// watch-stream's internal target bookkeeping (a known SDK interaction bug,
// not a missing-cleanup bug in this app's own listeners — AuthContext's and
// GamesContext's effects both already return proper unsubscribe functions).
// Once it fires, the whole Firestore connection is dead until a hard
// reload, and production builds never double-invoke effects anyway, so
// StrictMode's diagnostic value here doesn't outweigh the breakage.
createRoot(document.getElementById('root')).render(<App />)
