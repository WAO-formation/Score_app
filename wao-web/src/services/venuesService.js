// venuesService.js
//
// `venues/{venueId}` = { name, createdAt }. Rules: read = signed-in,
// create/update/delete = admin only (see wao_mobile/firestore.rules) — the
// UI in Venues.jsx hides/disables write controls for moderators to match.
// CreateGame.jsx's venue picker reads this same collection.
import {
  collection, doc, addDoc, updateDoc, deleteDoc, onSnapshot, serverTimestamp,
} from 'firebase/firestore';
import { db } from '../lib/firebase';

const VENUES = 'venues';

export function subscribeToVenues(onData, onError) {
  return onSnapshot(
    collection(db, VENUES),
    (snap) => {
      const list = snap.docs.map((d) => ({ id: d.id, name: d.data().name || '' }));
      list.sort((a, b) => a.name.localeCompare(b.name));
      onData(list);
    },
    onError
  );
}

export async function createVenue(name) {
  await addDoc(collection(db, VENUES), { name, createdAt: serverTimestamp() });
}

export async function updateVenue(id, name) {
  await updateDoc(doc(db, VENUES, id), { name });
}

export async function deleteVenue(id) {
  await deleteDoc(doc(db, VENUES, id));
}
