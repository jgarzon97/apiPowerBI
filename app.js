const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());

const pool = new Pool({
    user: 'dwcamaronera_kixb_user',
    host: 'dpg-cp96rmtds78s73cdssdg-a.oregon-postgres.render.com',
    database: 'dwcamaronera_kixb',
    password: '0UmZDXKibT6WcZOVZRsNYZeqtn5JrBqk',
    port: 5432,
    ssl: {
        rejectUnauthorized: false,
    }
});

app.get('/api/data/vi_piscina', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM "vi_Piscina"');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error' });
    }
});

app.get('/api/data/vi_cosecha', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM "vi_cosecha"');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error' });
    }
});

app.get('/api/data/vi_piscina_corrida', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM "vi_piscina_corrida"');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error' });
    }
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});