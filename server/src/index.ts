import express from 'express';
import mongoose from 'mongoose';
import * as dotenv from 'dotenv';
import userRouter from './routes/user.route';
import connect from './connect'
dotenv.config();

const app = express();
const PORT: number = process.env.PORT ? parseInt(process.env.PORT): 3001;
const uri = `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.DB_SERVER}`;

app.use('/api/user', userRouter);

connect(uri)
app.listen(PORT, () => console.log(`Listening on port ${PORT}`))