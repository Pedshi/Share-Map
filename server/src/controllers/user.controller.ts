import { User, IUser } from '../models/user.model'
import { CreateQuery, Types } from 'mongoose';
import express from 'express';
import { IPlace } from '../models/place.model';


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
          .catch( (error: Error) => { throw error });
};

async function addPlace(id: string, placeId: string): Promise<IUser | null> {
  return User.findOneAndUpdate(
            {_id : id},
            { '$addToSet': {places: [placeId] as any } },
            {'upsert': true}
         )
          .then( (data: IUser | null) => data )
          .catch( (error: Error) => { throw error; } );
};

async function getPlaces(id: string): Promise<Types.ObjectId[] | IPlace[] | undefined> {
  return User.findOne({_id: id})
          .populate('places').exec()
          .then( (data: IUser | null) => { return data!.places} )
          .catch( (error: Error) => { throw error } );
};

export default {
  createUser,
  login,
  addPlace,
  getPlaces
};