const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const cloudinary = require('cloudinary').v2;
const multer = require('multer'); // Agrega la dependencia multer

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

const MONGODB_URI = "mongodb+srv://kevinfge2410:kevinfge2410@productos.3wpf6g4.mongodb.net/?retryWrites=true&w=majority";

mongoose.connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
});

// Configura Cloudinary con tus credenciales
cloudinary.config({
  cloud_name: 'du9dasmxo',
  api_key: '528543336395412',
  api_secret: 'JZHnJiAU-uUQyqJlLIfw5Z4aMAg',
});

const ProductSchema = new mongoose.Schema({
    name: String,
    description: String,
    price: Number,
    imageUrl: String
});

const Product = mongoose.model('Product', ProductSchema);

// Ruta para subir una imagen a Cloudinary y obtener su URL
app.post('/upload', async (req, res) => {
  try {
    const result = await cloudinary.uploader.upload(req.body.imageBase64, {
      folder: 'carpeta_en_cloudinary', // Opcional: especifica una carpeta en Cloudinary
    });

    const imageUrl = result.secure_url; // URL de la imagen en Cloudinary

    res.json({ imageUrl });
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Rutas CRUD
app.get('/products', async (req, res) => {
    try {
        const products = await Product.find();
        res.json(products);
    } catch (err) {
        res.status(500).send(err.message);
    }
});


//Create Product
app.post('/products', async (req, res) => {
    try {
        // Asegúrate de que req.body incluye la URL de la imagen de Cloudinary
        const product = new Product(req.body);
        await product.save();
        res.status(201).json(product);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

app.put('/products/:id', async (req, res) => {
    try {
        const product = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json(product);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

app.delete('/products/:id', async (req, res) => {
    try {
        await Product.findByIdAndDelete(req.params.id);
        res.status(204).send();
    } catch (err) {
        res.status(500).send(err.message);
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
