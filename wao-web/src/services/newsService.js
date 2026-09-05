// newsService.js
//
// `news/{newsId}` mirrors wao_mobile's NewsModel exactly (see
// wao_mobile/lib/Model/news/news_model.dart) so articles written here show
// up on mobile with no translation layer needed:
//   { imageUrl, title, mainParagraph: {subtitle, content},
//     optionalParagraphs: [{subtitle, content}]|null, publishedDate
//     (Timestamp), author, category }
// Rules (firestore.rules): read = any signed-in user, create/update/delete =
// admin only — News.jsx hides/disables write controls for a moderator to
// match, same pattern as Venues.jsx/Officials.jsx.
//
// imageUrl is expected to be either a direct image URL or a Google Drive
// share link — mobile's DriveImage.resolve() converts Drive links to a
// direct-loadable form on its own, so this layer just stores whatever URL
// the admin pastes verbatim.
import {
  collection, doc, addDoc, updateDoc, deleteDoc, onSnapshot, query, orderBy,
  Timestamp,
} from 'firebase/firestore';
import { db } from '../lib/firebase';

const NEWS = 'news';

function docToArticle(id, data) {
  return {
    id,
    imageUrl: data.imageUrl || '',
    title: data.title || '',
    mainParagraph: {
      subtitle: data.mainParagraph?.subtitle || '',
      content: data.mainParagraph?.content || '',
    },
    optionalParagraphs: (data.optionalParagraphs || []).map((p) => ({
      subtitle: p.subtitle || '',
      content: p.content || '',
    })),
    publishedDate: data.publishedDate?.toDate ? data.publishedDate.toDate() : new Date(),
    author: data.author || '',
    category: data.category || '',
  };
}

// article.publishedDate is a JS Date; everything else is already in the
// on-disk shape (see docToArticle above).
function articleToDoc(article) {
  return {
    imageUrl: article.imageUrl,
    title: article.title,
    mainParagraph: {
      subtitle: article.mainParagraph.subtitle || null,
      content: article.mainParagraph.content,
    },
    optionalParagraphs: article.optionalParagraphs.length
      ? article.optionalParagraphs.map((p) => ({ subtitle: p.subtitle || null, content: p.content }))
      : null,
    publishedDate: Timestamp.fromDate(article.publishedDate instanceof Date ? article.publishedDate : new Date(article.publishedDate)),
    author: article.author || null,
    category: article.category || null,
  };
}

export function subscribeToNews(onData, onError) {
  const q = query(collection(db, NEWS), orderBy('publishedDate', 'desc'));
  return onSnapshot(
    q,
    (snap) => onData(snap.docs.map((d) => docToArticle(d.id, d.data()))),
    onError
  );
}

export async function createNews(article) {
  await addDoc(collection(db, NEWS), articleToDoc(article));
}

export async function updateNews(id, article) {
  await updateDoc(doc(db, NEWS, id), articleToDoc(article));
}

export async function deleteNews(id) {
  await deleteDoc(doc(db, NEWS, id));
}
