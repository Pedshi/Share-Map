import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

export const userReducerName = 'user';

const LOGIN = userReducerName + '/login';

const initialState = {
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
      .addCase(loginUser.pending, (state) => {
        state.status = 'loading';
      })
  }
});

export default userSlice.reducer;