import { BrowserRouter, Switch, Route } from 'react-router-dom';
import LoginScreen from '../features/login/login';
import PlaceScreen from '../features/place/place';

function App() {

  return (
    <BrowserRouter>
      <div className="wrapper">
        <Switch>
          <Route path={'/place/create'} exact component={PlaceScreen}/>
          <Route path={'/'} component={LoginScreen}/>
        </Switch>
      </div>
    </BrowserRouter>
  );
}

export default App;
