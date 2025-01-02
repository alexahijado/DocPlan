exports.sendReminder = async (req, res) => {
  try {
    const { appointmentId } = req.body;
    const appointment = await Appointment.findById(appointmentId).populate('doctor patient');

    if (!appointment) return res.status(404).json({ message: 'Appointment not found' });

    const doctor = await User.findById(appointment.doctor);
    if (!doctor || !doctor.senderEmail) {
      return res.status(400).json({ message: 'Doctor email not configured for notifications' });
    }

    const message = `Reminder: You have an appointment scheduled on ${appointment.date}.`;

    // Send email from the doctor's custom email
    const email = {
      to: appointment.patient.email,
      from: doctor.senderEmail, // Use the doctor's email
      subject: 'Appointment Reminder',
      text: message,
    };

    try {
      await sgMail.send(email);
    } catch (error) {
      console.error('Error sending email:', error.response ? error.response.body : error.message);
      return res.status(500).json({ message: 'Failed to send email reminder' });
    }

    // Send SMS using a generic phone number
    try {
      const smsResponse = await twilioClient.messages.create({
        body: message,
        from: process.env.TWILIO_PHONE_NUMBER, // Generic phone number
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
