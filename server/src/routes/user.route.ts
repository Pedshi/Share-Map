import express, { NextFunction } from 'express';
import UserController from '../controllers/user.controller';
import { Error } from 'mongoose';
import { authMiddlewareParams, authenticateUserToken } from '../middlewares/auth.middleware';

const userRouter = express.Router();

userRouter.get('/', async (request, result) => {
  const users = await UserController.getUsers()
    .catch( err => { console.log(err) })
  result.send(users);
});

userRouter.post('/signup', async (req, res, next) => {
  try{
    const user = await UserController.createUser(req);
    const uiUser = {
      id: user.id,
      email: user.email,
      token: user.token
    };
    res.status(201).send(uiUser);
  }catch(error){ next(error); }
});

userRouter.post('/login', async (req, res, next) => {
  const {email, password} = req.body;
  if( !email || !password)
    return next(new Error('Empty Fields'));
  try{
    const token = await UserController.login({email, password});
    res.cookie('_t', token, {httpOnly: true}).sendStatus(200);
  }catch(error){ next(error); }
});

const refreshTokenCB = async (req: express.Request<authMiddlewareParams>, res: express.Response, next: NextFunction) => {
  const {email} = req.body;
  if( !email || email == '')
    next( new Error('Email needed') );
  if( req.params.user.email == email )
    return res.sendStatus(200);
  next( new Error('Not authorized') );
};

userRouter.get('/refreshtoken', authenticateUserToken ,refreshTokenCB);

export default userRouter