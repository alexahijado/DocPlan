const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String },
  role: { type: String, enum: ['doctor', 'patient'], required: true },
  senderEmail: { type: String }, // Correo personalizado para enviar notificaciones
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
