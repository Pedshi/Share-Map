import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

export const authReducerName = 'authentication';

const LOGIN = authReducerName + '/loginUser';
const AUTHENTICATE_USER = authReducerName + '/authenticateUser';

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

export const authenticateUser = createAsyncThunk(
  AUTHENTICATE_USER,
  async (user) => {
    try{
      await axios.post('/api/user/auth');
      return {};
    }catch(error) { throw error }
  }
);

const isActionPending = (action) => {
  return action.meta && action.meta.requestStatus === 'pending';
};

const authSlice = createSlice({
  name: authReducerName,
  initialState,
  reducers: {},
  extraReducers: builder => {
    builder
      .addCase(loginUser.fulfilled, (state) => {
        state.authenticated = true;
        state.status = 'idle';
      })
      .addCase(loginUser.rejected, (state, { error }) => {
        state.error = error.message;
        state.status = 'rejected';
      })
      .addCase(authenticateUser.fulfilled, (state) => {
        state.authenticated = true;
        state.status = 'idle';
      })
      .addCase(authenticateUser.rejected, (state) => {
        state.authenticated = false;
        state.status = 'idle';
      })
      .addMatcher(isActionPending, (state) => {
        state.status = 'loading';
      })
  }
});

export default authSlice.reducer;