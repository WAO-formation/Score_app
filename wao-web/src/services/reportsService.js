// reportsService.js
//
// wao-web-only collection — no wao_mobile equivalent. Reports link back to a
// real match (matchId) instead of a free-text game string, using the label
// callers build from useGames()'s live `games` array (see Reports.jsx).
// Rules (wao_mobile/firestore.rules): read = signed-in, create/update =
// isOfficial() (covers wao-web's admin + moderator accounts), delete = admin only.
import {
  collection, doc, addDoc, updateDoc, deleteDoc, onSnapshot,
  query, orderBy, serverTimestamp,
} from 'firebase/firestore';
import { db } from '../lib/firebase';

const REPORTS = 'reports';

function docToReport(id, data) {
  const createdAt = data.createdAt;
  return {
    id,
    matchId: data.matchId || '',
    matchLabel: data.matchLabel || '',
    type: data.type || '',
    description: data.description || '',
    status: data.status || 'pending',
    createdBy: data.createdBy || '',
    createdByName: data.createdByName || '',
    createdAt: typeof createdAt?.toDate === 'function' ? createdAt.toDate() : null,
  };
}

export function subscribeToReports(onData, onError) {
  const q = query(collection(db, REPORTS), orderBy('createdAt', 'desc'));
  return onSnapshot(
    q,
    (snap) => onData(snap.docs.map((d) => docToReport(d.id, d.data()))),
    onError
  );
}

export async function createReport({ matchId, matchLabel, type, description, createdBy, createdByName }) {
  await addDoc(collection(db, REPORTS), {
    matchId: matchId || null,
    matchLabel: matchLabel || '',
    type,
    description,
    status: 'pending',
    createdBy: createdBy || '',
    createdByName: createdByName || '',
    createdAt: serverTimestamp(),
  });
}

export async function updateReportStatus(id, status) {
  await updateDoc(doc(db, REPORTS, id), { status });
}

export async function deleteReport(id) {
  await deleteDoc(doc(db, REPORTS, id));
}
