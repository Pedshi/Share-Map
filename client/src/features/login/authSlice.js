import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

export const authReducerName = 'authentication';

const LOGIN = authReducerName + '/loginUser';

const initialState = {
  user: {},
  status: 'idle',
  authenticated: false,
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

const authSlice = createSlice({
  name: authReducerName,
  initialState,
  reducers: {},
  extraReducers: builder => {
    builder
      .addCase(loginUser.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(loginUser.fulfilled, (state) => {
        state.authenticated = true;
        state.status = 'idle';
      })
      .addCase(loginUser.rejected, (state, payload) => {
        state.error = payload.error.message;
        state.status = 'rejected';
      })
  }
});

export default authSlice.reducer;