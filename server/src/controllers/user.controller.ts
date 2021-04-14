import { User, IUser } from '../models/user.model'
import express from 'express';

async function getUsers(): Promise<IUser[]> {
  return await User.find().exec()
    .then( (data: IUser[]) => { return data; })
    .catch( error => { throw error; });
};

async function createUser( request: express.Request ): Promise<IUser> {
  const user = new User(request.body);
  user.token = user.generateAuthToken();
  return User.create(user)
          .then( (data: IUser) => data )
          .catch( (error: Error) => {throw error;} );
}

export default {
  getUsers,
  createUser
};