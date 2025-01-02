// controllers/appointmentController.js
const Appointment = require('../models/Appointment');

exports.createAppointment = async (req, res) => {
  try {
    const { doctor, patient, date } = req.body;

    const newAppointment = new Appointment({
      doctor,
      patient,
      date,
    });

    await newAppointment.save();
    res.status(201).json({ message: 'Appointment created successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getAppointments = async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query; // Pagination parameters
    const appointments = await Appointment.find()
      .populate('doctor patient')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .exec();

    const count = await Appointment.countDocuments();

    res.status(200).json({
      appointments,
      totalPages: Math.ceil(count / limit),
      currentPage: Number(page),
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
