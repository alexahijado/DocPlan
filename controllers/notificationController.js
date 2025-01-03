// controllers/notificationController.js
const Appointment = require('../models/Appointment');
const sgMail = require('@sendgrid/mail');
const twilio = require('twilio');

sgMail.setApiKey(process.env.SENDGRID_API_KEY);
const twilioClient = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

exports.sendReminder = async (req, res) => {
  try {
    const { appointmentId } = req.body;
    const appointment = await Appointment.findById(appointmentId).populate('doctor patient');

    if (!appointment) return res.status(404).json({ message: 'Appointment not found' });

    const message = `Reminder: You have an appointment scheduled on ${appointment.date}.`;

    // Send email
    const email = {
      to: appointment.patient.email,
      from: process.env.EMAIL_FROM,
      subject: 'Appointment Reminder',
      text: message,
    };

    try {
      await sgMail.send(email);
    } catch (error) {
      console.error('Error sending email:', error.response ? error.response.body : error.message);
      return res.status(500).json({ message: 'Failed to send email reminder' });
    }

    // Send SMS
    try {
      const smsResponse = await twilioClient.messages.create({
        body: message,
        from: process.env.TWILIO_PHONE_NUMBER,
        to: appointment.patient.phoneNumber,
      });
      console.log('SMS sent:', smsResponse.sid);
    } catch (error) {
      console.error('Error sending SMS:', error.response ? error.response.body : error.message);
      return res.status(500).json({ message: 'Failed to send SMS reminder' });
    }

    res.status(200).json({ message: 'Reminder sent successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};