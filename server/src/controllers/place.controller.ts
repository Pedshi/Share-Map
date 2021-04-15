import { Request } from 'express';
import { Place, IPlace } from '../models/place.model';
import { authMiddlewareParams } from '../middlewares/auth.middleware';

async function create(req: Request<authMiddlewareParams>): Promise<IPlace>{
    const newPlace = new Place(req.body);
    return Place.create(newPlace)
      .then( (data: IPlace) => data )
      .catch( (error: Error) => { throw error; } );
};

async function getAll(): Promise<IPlace[]> {
  return Place.find().exec()
    .then( (data: IPlace[]) => data )
    .catch( (error: Error) => { throw error; } );
}

export default {
  create,
  getAll
}