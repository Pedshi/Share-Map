import { model, Schema, Document } from 'mongoose';

interface IUser{
  email: {type:String, required: true, unique:true};
  password: {type:String, required: true};
  isAdmin: {type:Boolean, required:true, default:false};
  token: {type:String};
};

interface IUserDoc extends IUser, Document {};

const userSchemaFields: Record<keyof IUser, any> = {
  email: {type:String, required: true, unique:true},
  password: {type:String, required: true},
  isAdmin: {type:Boolean, required:true, default:false},
  token: {type:String}
};
const userSchema = new Schema({userSchemaFields});

const User = model<IUserDoc>('User', userSchema);
export { IUser, User }
