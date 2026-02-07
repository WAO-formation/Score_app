import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyAerNcQyVOZaJsb0QMfQ8KJdwogRM1nYag",
  authDomain: "wao-mobile-app-7e3c9.firebaseapp.com",
  projectId: "wao-mobile-app-7e3c9",
  storageBucket: "wao-mobile-app-7e3c9.firebasestorage.app",
  messagingSenderId: "556690053319",
  appId: "1:556690053319:web:f2e2163fd95488b4c3c6e2"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);