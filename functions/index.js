const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();


const message = {
  data: {
    title: "Water content Alert",
    text: "Water content is low need irrigation",
  },
  token:
    "d03-u69MQbqMVAWYpZxyK-:APA91bFac_4Kl_O2QRsmnkBqkx9VoYshVFY99lgH45ulfqjI_uoOCUYVIYya_d-fFQHqrCQ16kV1S8nqyd4_4WrI67bjrCokcSb7beo6Oo9mXwI07m5HVTbIgrbWaFOW98lmGFvEhq0p",
};
exports.sendNotification = functions.database
  .ref("/moisture_sensor/value")
    .onUpdate((snapshot, context) => {

    if (snapshot.after.val() == 60) {
      admin.messaging().send(message);
    }
  });


//   exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });