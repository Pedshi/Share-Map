import { useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { loginUser, authReducerName } from './authSlice';
import { Redirect } from 'react-router-dom';

function Login() {

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const { authenticated, user, status} = useSelector(state => state[authReducerName]);
  const dispatch = useDispatch();
  
  const onSubmitHandler = (e) => {
    e.preventDefault();
    dispatch(loginUser({email, password}));
  };

  const renderStatusEffect = (status) => {
    switch (status) {
      case 'loading':
        return (
          <div className="loader-container">
            <div className="loader"></div>
          </div>
        );
      case 'rejected':
        return (
          <div>
            <p>User credentials wrong!</p>
          </div>
        )
      default:
        return (<div></div>);
    };
  };

  return (
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
      {renderStatusEffect(status)}
      {authenticated && (
        <Redirect to="/place/create"/>
      )}
    </div>
  );
}

export default Login;