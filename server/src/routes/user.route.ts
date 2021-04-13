import express from 'express';
import UserController from '../controllers/user.controller';

const userRouter = express.Router();

userRouter.get('/', async (request, result) => {
  const users = await UserController.getUsers()
    .catch( err => { console.log(err) })
  result.send(users);
});

userRouter.post('/create', async (req, res) => {
  const user = await UserController.createUser({
    email: req.body.email,
    password: req.body.password
  })
    .catch( err => { console.log(err); });
  res.send(user);
});

export default userRouter