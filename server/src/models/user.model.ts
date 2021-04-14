import { model, Schema, Document } from 'mongoose';
import jwt from 'jsonwebtoken';
import * as dotenv from 'dotenv';
import bcrypt from 'bcryptjs';
dotenv.config();

/*
  Interface
*/
interface IUserKeys{
  email: {type:String, required: true, unique:true};
  password: {type:String, required: true};
  isAdmin?: {type:Boolean, required:true, default:false};
  token?: {type:String};
};

interface IUser extends Document {
  email: string;
  password: string;
  isAdmin?: boolean;
  token?: string;
  hashPassword(password: string): Promise<string>;
  generateAuthToken(): string;
};

/*
 Schema
*/
const userSchemaFields: Record<keyof IUserKeys, any> = {
  email: {
    type: String, 
    required: [true, 'Missing Email address'], 
    unique: true, 
    lowercase: true
  },
  password: {
    type: String, 
    required: [true, 'Missing Password'],
  },
  isAdmin: {
    type: Boolean, 
    required: true, 
    default: false
  },
  token: String
};
const userSchema = new Schema(userSchemaFields);

/*
 Statics & methods
*/
userSchema.methods.hashPassword = async function(password: string): Promise<string> {
  const salt = await bcrypt.genSalt();
  return await bcrypt.hash(password, salt);
};

userSchema.methods.generateAuthToken = function(){
  const user = this;
  const newToken = jwt.sign({_id: user._id}, process.env.JWT_KEY!, {expiresIn: '7d'});
  return newToken;
}

userSchema.pre<IUser>('save', async function(next) {
  const user = this;
  if(user.isModified('password')){
    try{
      user.password = await this.hashPassword(user.password);
      next();
    }catch(error){ next(error); }
  }
});


const User = model<IUser>('User', userSchema);
export { IUser, User }
