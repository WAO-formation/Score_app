// championshipsService.js
//
// Mirrors wao_mobile's `championships/{championshipId}` collection (Dart
// model: WaoChampionship) = { name, scope, targetCampusIds, createdAt }.
// wao-web's simple "Tournaments" UI only ever creates general-scope
// championships (scope: 'general', targetCampusIds: []) — the
// campus-restriction concept is mobile-only for now, no picker here.
// Rules: read = signed-in, create/update/delete = admin only — Tournaments.jsx
// hides/disables write controls for moderators to match.
// CreateGame.jsx's tournament picker reads this same collection.
import {
  collection, doc, addDoc, updateDoc, deleteDoc, onSnapshot, serverTimestamp,
} from 'firebase/firestore';
import { db } from '../lib/firebase';

const CHAMPIONSHIPS = 'championships';

export function subscribeToChampionships(onData, onError) {
  return onSnapshot(
    collection(db, CHAMPIONSHIPS),
    (snap) => {
      const list = snap.docs.map((d) => ({
        id: d.id,
        name: d.data().name || '',
        scope: d.data().scope || 'general',
        targetCampusIds: d.data().targetCampusIds || [],
      }));
      list.sort((a, b) => a.name.localeCompare(b.name));
      onData(list);
    },
    onError
  );
}

export async function createChampionship(name) {
  await addDoc(collection(db, CHAMPIONSHIPS), {
    name,
    scope: 'general',
    targetCampusIds: [],
    createdAt: serverTimestamp(),
  });
}

export async function updateChampionship(id, name) {
  await updateDoc(doc(db, CHAMPIONSHIPS, id), { name });
}

export async function deleteChampionship(id) {
  await deleteDoc(doc(db, CHAMPIONSHIPS, id));
}
