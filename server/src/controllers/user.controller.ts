import { User, IUser } from '../models/user.model'
import { CreateQuery } from 'mongoose';
import express from 'express';

async function getUsers(): Promise<IUser[]> {
  return User.find().exec()
    .then( (data: IUser[]) => { return data; })
    .catch( error => { throw error; });
};

async function createUser( request: express.Request ): Promise<IUser> {
  const user = new User(request.body);
  user.token = await user.generateAuthToken();
  return User.create(user)
          .then( (data: IUser) => data )
          .catch( (error: Error) => {throw error;} );
};

async function login( {email, password}:CreateQuery<IUser> ): Promise<string> {
  return User.findByCredentials(email, password)
          .then( (data: IUser) => { return data.generateAuthToken(); })
          .then( (token: string) => { return token; })
          .catch( (err: Error) => { throw err });
};

export default {
  getUsers,
  createUser,
  login
};