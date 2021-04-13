import { model, Schema, Document } from 'mongoose';

interface IUserKeys{
  email: {type:String, required: true, unique:true};
  password: {type:String, required: true};
  isAdmin?: {type:Boolean, required:true, default:false};
  token?: {type:String};
};

interface IUser extends IUserKeys, Document {};

const userSchemaFields: Record<keyof IUserKeys, any> = {
  email: {type:String, required: true, unique:true},
  password: {type:String, required: true},
  isAdmin: {type:Boolean, required:true, default:false},
  token: {type:String}
};
const userSchema = new Schema(userSchemaFields);

const User = model<IUser>('User', userSchema);
export { IUser, User }
