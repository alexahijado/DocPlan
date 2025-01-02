// server.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');
const appointmentRoutes = require('./routes/appointments');
const authRoutes = require('./routes/auth');
const notificationRoutes = require('./routes/notifications');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(bodyParser.json());

// MongoDB Connection
const connectWithRetry = () => {
  mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
    .then(() => console.log('MongoDB connected'))
    .catch(err => {
      console.error('MongoDB connection error:', err);
      console.log('Retrying in 5 seconds...');
      setTimeout(connectWithRetry, 5000); // Retry after 5 seconds
    });
};

connectWithRetry();

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/notifications', notificationRoutes);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});