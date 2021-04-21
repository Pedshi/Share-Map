import { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { loginUser, userReducerName } from './userSlice';
import { Redirect } from 'react-router-dom';
import { renderStatusEffect } from '../../common/inputWLabel';

function Login() {

  const [ email, setEmail ] = useState('');
  const [ password, setPassword ] = useState('');
  const { authenticated, status } = useSelector(state => state[userReducerName]);
  const dispatch = useDispatch();
  
  const onSubmitHandler = (event) => {
    event.preventDefault();
    dispatch(loginUser({ email, password }));
  };

  return (
    <div className="wrapper">
      <div className="form-container">
        <form onSubmit={onSubmitHandler}>
          <input type="email" 
            value={email}
            onChange={e => setEmail(e.target.value)}
            placeholder="Email" />
          <br/>
          <input type="password" 
            value={password}
            onChange={e => setPassword(e.target.value)}
            placeholder="Password" />
          <br/>
          <div className="form-button-wrapper">
            <input type="submit" value="Login"/>
          </div>
        </form>
        {renderStatusEffect(status, 'User credentials wrong!')}
        {authenticated && (
          <Redirect to="/place/create"/>
        )}
      </div>
    </div>
  );
}

export default Login;