import { model, Schema, Document } from 'mongoose';

/*  
  Interfaces
*/
interface IOpeninHours {
  mon : {type: String, required: true};
  tue : {type: String, required: true};
  wed : {type: String, required: true};
  thu : {type: String, required: true};
  fri : {type: String, required: true};
  sat : {type: String, required: true};
  sun : {type: String, required: true};
}

interface IPlace {
  owner: {type: String, required: true},
  name: {type: String, required: true},
  address: {type: String, required: true},
  latitude: {type: Number, required: true},
  longitude: {type: Number, required: true},
  igLocationUrl: {type: String},
  openingHours: IOpeninHours,
  category: {type: Number}
};

interface IPlaceDoc extends IPlace, Document {};

/* 
  Schemas 
*/
const openingHoursFields: Record<keyof IOpeninHours, any> = {
  mon : {type: String, required: true},
  tue : {type: String, required: true},
  wed : {type: String, required: true},
  thu : {type: String, required: true},
  fri : {type: String, required: true},
  sat : {type: String, required: true},
  sun : {type: String, required: true}
};
const openingHoursSchema = new Schema(openingHoursFields);

const placeSchemaFields: Record<keyof IPlace, any> = {
  owner: {type: String, required: true},
  name: {type: String, required: true},
  address: {type: String, required: true},
  latitude: {type: Number, required: true},
  longitude: {type: Number, required: true},
  igLocationUrl: {type: String},
  openingHours: openingHoursSchema,
  category: {type: Number}
};
const placeSchema = new Schema(placeSchemaFields);

const Place = model<IPlaceDoc>("Place", placeSchema);
export { IPlace, Place };