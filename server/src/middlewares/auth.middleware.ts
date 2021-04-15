import express, { NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { Error } from 'mongoose';
import {User, IUser} from '../models/user.model';

interface authMiddlewareParams{
  user: IUser;
}

const authenticateUserToken = async (req: express.Request<authMiddlewareParams>, res: express.Response, next: NextFunction) => {
  if(!req.cookies || !req.cookies._t)
    return next( new Error('Missing Cookie') );
  const token = req.cookies._t;
  try{
    const data = <any>jwt.verify(token, process.env.JWT_KEY!);
    const user = await User.findOne({_id: data._id, token: token});
    if(!user)
      throw new Error('Token invalid');
    req.params.user = user;
    next();
  }catch(error) { next(error) }
};

export { 
  authenticateUserToken,
  authMiddlewareParams
}