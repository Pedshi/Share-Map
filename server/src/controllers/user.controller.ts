import { User, IUser } from '../models/user.model'
import { CreateQuery } from 'mongoose';
async function getUsers(): Promise<IUser[]> {
  return await User.find().exec()
    .then( (data: IUser[]) => { return data; })
    .catch( error => { throw error; });
};

async function createUser( 
  { email, password }: CreateQuery<IUser> ): Promise<IUser> {
  return await User.create({email, password})
    .then( (data: IUser) => {
      return data;
    })
    .catch( err => { throw err; } );
}

export default {
  getUsers,
  createUser
};