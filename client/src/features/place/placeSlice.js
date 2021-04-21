import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

export const placeReducerName = 'place';

const CREATE = placeReducerName + '/create';

const initialState = {
  place: null,
  status: 'idle',
  error: null
}

export const createPlace = createAsyncThunk(
  CREATE,
  async (place) => {
    try{
      const newplace = await axios.post('/api/place', place);
      return newplace.data;
    }catch(error) { throw error }
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
  }
});

export default placeSlice.reducer;