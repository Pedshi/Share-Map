import express, { NextFunction } from 'express';
import { Error } from 'mongoose';

const validationErrorHandler = (error: Error.ValidationError, res: express.Response) => {
  const message = Object.values(error.errors).map(err => err.message);
  const code = 400;
  const joinedMessages = message.join(', ');
  res.status(code).send( joinedMessages );
};

function errorMiddleware(error: Error, req: express.Request, res: express.Response, next: NextFunction): void {
  if( error.name == 'ValidationError' )
    validationErrorHandler(error as Error.ValidationError, res);
  else 
    res.status(500).send('Unknown Error');
};

export default errorMiddleware;
