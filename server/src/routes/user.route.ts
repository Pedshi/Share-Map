import express, { NextFunction, Request, Response } from 'express';
import UserController from '../controllers/user.controller';
import { Error } from 'mongoose';
import { authMiddlewareParams, authenticateUserToken } from '../middlewares/auth.middleware';

const userRouter = express.Router();

enum UserPaths {
  signUp = '/signup',
  login = '/login',
  refreshToken = '/refreshtoken',
  addPlace = '/place/:placeId',
  getPlaces = '/place'
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

userRouter.get(UserPaths.refreshToken, authenticateUserToken , refreshTokenCB);

interface addPlaceParams extends authMiddlewareParams{
  placeId: string;
}

const addPlaceCB = async (req: Request<addPlaceParams>, res: Response, next: NextFunction) => {
  try{
    const user = await UserController.addPlace(req.params.user.id, req.params.placeId);
    if(!user)
      return res.status(404).send('User does not exist');
    return res.sendStatus(200);
  }catch(error) { next(error) }
};

userRouter.put(UserPaths.addPlace, authenticateUserToken, addPlaceCB);

const getPlacesCB = async (req: Request<authMiddlewareParams>, res: Response, next: NextFunction) => {
  try{
    const places = await UserController.getPlaces(req.params.user.id!);
    if(!places)
      return res.status(404).send('No places to show');
    return res.send(places);
  }catch(error) { throw error }
};

userRouter.get(UserPaths.getPlaces, authenticateUserToken, getPlacesCB);

export default userRouter