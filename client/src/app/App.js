import { BrowserRouter, Switch, Route } from 'react-router-dom';
import LoginScreen from '../features/login/login';
import PlaceScreen from '../features/place/place';
import PrivateRoute from '../common/privateRoute';

function App() {

  return (
    <BrowserRouter>
      <Switch>
        <PrivateRoute path={'/place/create'}>
          <PlaceScreen />
        </PrivateRoute>

        <Route path={'/'}>
          <LoginScreen />
        </Route>
        
      </Switch>
    </BrowserRouter>
  );
}

export default App;
