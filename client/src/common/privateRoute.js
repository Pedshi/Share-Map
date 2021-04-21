import { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { Route, Redirect } from 'react-router-dom';

import { authReducerName, authenticateUser } from '../features/login/authSlice';
import { renderStatusEffect } from '../common/inputWLabel';

function PrivateRouter({ children }){
  
  const { authenticated, status } = useSelector(state => state[authReducerName]);
  const dispatch = useDispatch();
  useEffect( () => {
    if (!authenticated)
      dispatch(authenticateUser());
  },[]);

  return (
    <div>
      {status === 'loading' ? (
         renderStatusEffect(status) 
      ):(
        <Route
          render={ () => authenticated ? ( children ) : ( <Redirect to="/"/> ) }
        />
      )}
    </div>
  );
}

export default PrivateRouter;