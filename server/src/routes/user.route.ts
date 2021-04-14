import express from 'express';
import UserController from '../controllers/user.controller';

const userRouter = express.Router();

userRouter.get('/', async (request, result) => {
  const users = await UserController.getUsers()
    .catch( err => { console.log(err) })
  result.send(users);
});

userRouter.post('/create', async (req, res) => {
  try{
    const user = await UserController.createUser(req);
    const uiUser = {
      id: user.id,
      email: user.email,
      token: user.token
    };
    res.status(201).send(uiUser);
  }catch(error){
    console.log(`Error creating user: ${error}`);
    res.status(404).send('Failed to create user');
  }
});

export default userRouter