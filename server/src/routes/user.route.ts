import express from 'express';
import { User, IUser } from '../models/user.model';

const userRouter = express.Router();

userRouter.get('/', (request, result) => {
  
  result.send('USER');
});

export default userRouter