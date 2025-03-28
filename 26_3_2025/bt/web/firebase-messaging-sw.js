importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyDtLJOGtwJV7IcXBuPFv1tnxuuDV-mTnzU",
  authDomain: "project-4315590107491761939.firebaseapp.com",
  projectId: "project-4315590107491761939",
  storageBucket: "project-4315590107491761939.appspot.com",
  messagingSenderId: "819254153590",
  appId: "1:819254153590:web:cc7be92bbbd9c33bb5ea57",
  measurementId: "G-2LJG7BMHWN",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
