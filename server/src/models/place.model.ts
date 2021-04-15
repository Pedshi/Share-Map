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

interface IPlaceKeys {
  name: {type: String, required: true},
  address: {type: String, required: true},
  latitude: {type: Number, required: true},
  longitude: {type: Number, required: true},
  igLocationUrl: {type: String},
  openingHours: IOpeninHours,
  category: {type: Number}
};

interface IPlace extends Document {
  name: string,
  address: string,
  latitude: number,
  longitude: number,
  igLocationUrl: string,
  openingHours: IOpeninHours,
  category: number
};

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

const placeSchemaFields: Record<keyof IPlaceKeys, any> = {
  name: {
    type: String, 
    required: [true, 'Missing name of Place']
  },
  address: {
    type: String, 
    required: [true, 'Missing address']
  },
  latitude: {
    type: Number, 
    required: [true, 'Missing latitude']
  },
  longitude: {
    type: Number, 
    required: [true, 'Missing longitude']
  },
  igLocationUrl: {type: String},
  openingHours: openingHoursSchema,
  category: {type: Number}
};
const placeSchema = new Schema(placeSchemaFields);

const Place = model<IPlace>("Place", placeSchema);
export { IPlace, Place };