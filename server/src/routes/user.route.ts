import express, { NextFunction, Request, Response } from 'express';
import UserController from '../controllers/user.controller';
import { Error } from 'mongoose';
import { authMiddlewareParams, authenticateUserToken } from '../middlewares/auth.middleware';

const userRouter = express.Router();

enum UserPaths {
  signUp = '/signup',
  login = '/login',
  refreshToken = '/refreshtoken'
}

const signUpCB = async (req: Request, res: Response, next: NextFunction) => {
  try{
    const user = await UserController.createUser(req);
    const uiUser = {
      id: user.id,
      email: user.email,
      token: user.token
    };
    res.status(201).send(uiUser);
  }catch(error){ next(error); }
};

userRouter.post(UserPaths.signUp, signUpCB);

const loginCB = async (req: Request, res: Response, next: NextFunction) => {
  const {email, password} = req.body;
  if( !email || !password)
    return next(new Error('Empty Fields'));
  try{
    const token = await UserController.login({email, password});
    res.cookie('_t', token, {httpOnly: true}).sendStatus(200);
  }catch(error){ next(error); }
};

userRouter.post(UserPaths.login, loginCB);

const refreshTokenCB = async (req: Request<authMiddlewareParams>, res: Response, next: NextFunction) => {
  const {email} = req.body;
  if( !email || email == '')
    next( new Error('Email needed') );
  if( req.params.user.email == email )
    return res.sendStatus(200);
  next( new Error('Not authorized') );
};

userRouter.get(UserPaths.refreshToken, authenticateUserToken ,refreshTokenCB);

export default userRouter