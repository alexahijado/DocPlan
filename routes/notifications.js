// routes/notifications.js
const express = require('express');
const { sendReminder } = require('../controllers/notificationController');

const router = express.Router();

router.post('/send', sendReminder);

module.exports = router;