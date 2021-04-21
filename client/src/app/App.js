import { BrowserRouter, Switch, Route } from 'react-router-dom';
import LoginScreen from '../features/login/login';
import PlaceScreen from '../features/createPlace/place';
import UserPlaceScreen from '../features/userPlaces/userPlace';
import PrivateRoute from '../common/privateRoute';

function App() {

  return (
    <BrowserRouter>
      <Switch>
        <PrivateRoute path={'/place/create'}>
          <PlaceScreen />
        </PrivateRoute>
        <PrivateRoute path={'/place/user'}>
          <UserPlaceScreen />
        </PrivateRoute>

        <Route path={'/'}>
          <LoginScreen />
        </Route>

      </Switch>
    </BrowserRouter>
  );
}

export default App;
