import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

export const placeReducerName = 'place';

const CREATE = placeReducerName + '/create';
const FETCH_ALL = placeReducerName + '/fetchAll'

const initialState = {
  place: null,
  places: [],
  status: 'idle',
  error: null
}

export const createPlace = createAsyncThunk(
  CREATE,
  async (place) => {
    try{
      const newplace = await axios.post('/api/place', place);
      return newplace.data;
    }catch(error) { throw error; }
  }
);

export const fetchAllPlaces = createAsyncThunk(
  FETCH_ALL,
  async () => {
    try{
      const places = await axios.get('/api/place');
      return places.data;
    }catch(error) { throw error; }
  }
);

const placeSlice = createSlice({
  name: placeReducerName,
  initialState,
  reducers: {},
  extraReducers: builder => {
    builder
      .addCase(createPlace.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(createPlace.fulfilled, (state, { payload }) => {
        state.place = payload;
        state.status = 'idle';
      })
      .addCase(createPlace.rejected, (state, action) => {
        state.error = action.error.message;
        state.status = 'rejected';
      })
      .addCase(fetchAllPlaces.pending, (state) => { 
        state.status = 'loading';
       })
      .addCase(fetchAllPlaces.fulfilled, (state, { payload }) => {
        state.places = payload;
        state.status = 'idle';
      })
      .addCase(fetchAllPlaces.rejected, (state, action) => {
        state.error = action.error.message;
        state.status = 'rejected';
      })
  }
});

export default placeSlice.reducer;