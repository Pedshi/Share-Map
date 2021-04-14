import express from 'express';
import * as dotenv from 'dotenv';
import userRouter from './routes/user.route';
import bodyParser from 'body-parser';
import connect from './connect';
import errorMiddleware from './middlewares/error.middleware';
dotenv.config();

const app = express();
const PORT: number = process.env.PORT ? parseInt(process.env.PORT): 3001;
const uri = `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASS}@${process.env.DB_SERVER}`;

app.use(bodyParser.json());

app.use('/api/user', userRouter);

app.use(errorMiddleware);
connect(uri)
app.listen(PORT, () => console.log(`Listening on port ${PORT}`))