import { createSlice, createAsyncThunk, isAnyOf } from '@reduxjs/toolkit';
import axios from 'axios';

export const userReducerName = 'user';

const LOGIN = userReducerName + '/login';
const ADD_PLACE = userReducerName + '/addPlace';

const initialState = {
  status: 'idle',
  authenticated: false,
  requestSuccess: false,
  error: null
};

export const loginUser = createAsyncThunk(
  LOGIN,
  async (user) => {
    try{
      await axios.post('/api/user/login', user);
      return {};
    }catch(error){ throw error }
  }
);

export const addPlace = createAsyncThunk(
  ADD_PLACE,
  async (placeId) => {
    try{
      await axios.put('/api/user/place/' + placeId);
      return {};
    }catch(error) { throw error; }
  }
);

const userSlice = createSlice({
  name: userReducerName,
  initialState,
  reducers: {},
  extraReducers: builder => {
    builder
      .addCase(loginUser.fulfilled, (state) => {
        state.authenticated = true;
        state.status = 'idle';
      })
      .addCase(loginUser.rejected, (state, { error }) => {
        state.authenticated = false;
        state.error = error.message;
        state.status = 'rejected';
      })
      .addCase(addPlace.fulfilled, (state) => {
        state.status = 'idle';
        state.requestSuccess = true;
      })
      .addCase(addPlace.rejected, (state, { error }) => {
        state.error = error.message;
        state.status = 'rejected';
      })
      .addMatcher(isAnyOf (loginUser.pending, addPlace.pending), (state) => {
        state.status = 'loading';
        state.requestSuccess = false;
      })
  }
});

export default userSlice.reducer;