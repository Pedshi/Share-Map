import mongoose,{ model, Schema, Document, Model, Types } from 'mongoose';
import jwt from 'jsonwebtoken';
import * as dotenv from 'dotenv';
import bcrypt from 'bcryptjs';
import { IPlace } from '../models/place.model';
dotenv.config();

/*
  Interface
*/

type ID = Types.ObjectId;

interface IUserKeys{
  email: string;
  password: string;
  isAdmin?: boolean;
  places?: ID[] | IPlace[];
  token?: string;
};

interface IUser extends Document {
  email: string;
  password: string;
  isAdmin?: boolean;
  places?: ID[] | IPlace[];
  token?: string;
  hashPassword(password: string): Promise<string>;
  generateAuthToken(): Promise<string>;
};

interface IUserModel extends Model<IUser> {
  findByCredentials(email: string, password: string): Promise<IUser>;
}

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
  places: [{
    type: Schema.Types.ObjectId,
    ref: 'Place'
  }],
  token: String
};
const userSchema = new Schema(userSchemaFields);

/*
 Statics & methods
*/
userSchema.statics.findByCredentials = async function(email: string, password: string): Promise<IUser> {
  const user = await User.findOne({email: email});
  if (user){
    const isPasswordMatch = await bcrypt.compare(password, user!.password);
    if(isPasswordMatch)
      return user;
  }
  throw new mongoose.Error('Login Failed');
};

userSchema.methods.hashPassword = async function(password: string): Promise<string> {
  const salt = await bcrypt.genSalt();
  return await bcrypt.hash(password, salt);
};

userSchema.methods.generateAuthToken = async function(): Promise<string>{
  const user = this as IUser;
  const newToken = jwt.sign({_id: user._id}, process.env.JWT_KEY!, {expiresIn: '7d'});
  user.token = newToken;
  await user.save();
  return newToken;
};

userSchema.pre<IUser>('save', async function(next) {
  const user = this;
  if(user.isModified('password')){
    try{
      user.password = await this.hashPassword(user.password);
      next();
    }catch(error){ next(error); }
  }
});

const User = model<IUser, IUserModel>('User', userSchema);
export { IUser, User }