const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendDangerNotification = functions.database
  .ref("/users/{uid}/sensors/{sensor}")
  .onUpdate(async (change, context) => {

    const before = change.before.val();
    const after = change.after.val();

    // Only trigger when OFF → ON
    if (before.status === "off" && after.status === "on") {

      const uid = context.params.uid;
      const sensor = context.params.sensor;

      // Get FCM token
      const tokenSnap = await admin.database()
        .ref(`/users/${uid}/fcmToken`)
        .once("value");

      const token = tokenSnap.val();

      if (!token) return null;

      const payload = {
        notification: {
          title: "🚨 Danger Detected",
          body: `${sensor} is ON`,
        },
        android: {
          priority: "high",
        }
      };

      return admin.messaging().sendToDevice(token, payload);
    }

    return null;
  });