import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

export const authReducerName = 'authentication';

const AUTHENTICATE_USER = authReducerName + '/authenticateUser';

const initialState = {
  user: {},
  status: 'loading',
  authenticated: false,
  error: null
};

export const authenticateUser = createAsyncThunk(
  AUTHENTICATE_USER,
  async () => {
    try{
      await axios.post('/api/user/auth');
      return {};
    }catch(error) { throw error }
  }
);

const authSlice = createSlice({
  name: authReducerName,
  initialState,
  reducers: {},
  extraReducers: builder => {
    builder
      .addCase(authenticateUser.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(authenticateUser.fulfilled, (state) => {
        state.authenticated = true;
        state.status = 'idle';
      })
      .addCase(authenticateUser.rejected, (state) => {
        state.authenticated = false;
        state.status = 'idle';
      })
  }
});

export default authSlice.reducer;