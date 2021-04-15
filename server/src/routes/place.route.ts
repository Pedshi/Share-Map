import { Router, Response, NextFunction, Request } from 'express';
import { authenticateUserToken, authMiddlewareParams } from '../middlewares/auth.middleware';
import PlaceController from '../controllers/place.controller';

const placeRouter = Router();

enum PlacePaths {
  create = '/',
  getAll = '/'
}

const createCB = async (req: Request<authMiddlewareParams>, res: Response, next: NextFunction) => {
  try{
    const newPlace = await PlaceController.create(req);
    res.status(201).send(newPlace);
  }catch(error){ next(error) }
};

placeRouter.post(PlacePaths.create, authenticateUserToken, createCB);

const getAllCB = async (req: Request, res: Response, next: NextFunction) => {
  try{
    const places = await PlaceController.getAll();
    res.send(places);
  }catch(error) { next(error) }
};

placeRouter.get(PlacePaths.getAll, getAllCB);

export default placeRouter;