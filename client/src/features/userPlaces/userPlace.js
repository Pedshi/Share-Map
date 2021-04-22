import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link } from 'react-router-dom';

import { renderStatusEffect } from '../../common/inputWLabel';
import { placeReducerName, fetchAllPlaces } from '../createPlace/placeSlice';
import { addPlace, userReducerName, fetchPlaces } from '../login/userSlice';

function UserPlace() {

  const [selectedPlace, setSelectedPlace] = useState(null);
  const { places, status } = useSelector( state => state[placeReducerName] );
  const { requestSuccess, places: userPlaces } = useSelector( state => state[userReducerName] );
  const dispatch = useDispatch();
  useEffect( () => {
    dispatch(fetchAllPlaces());
    dispatch(fetchPlaces());
  },[]);

  const addSelectedPlace = () => {
    if (selectedPlace)
      dispatch(addPlace(selectedPlace));
  };
  
  return (
    <div className="wrapper">
      <div className="form-container">
        <Link to="/place/create">
          <button>Go To Create Place</button>
        </Link>
        <div className="row-baseline">
          <p>You saved places:</p>
          <select onChange={ (e) => setSelectedPlace(e.target.value) }>
            { userPlaces.map( (userPlace) => (
              <option key={userPlace._id} value={userPlace._id}>
                { userPlace.name }
              </option>
            ))
            }
          </select>
        </div>
        <div className="row-baseline">
          <p>All places:</p>
          <select onChange={ (e) => setSelectedPlace(e.target.value) }>
            { places.map( (place) => (
              <option key={place._id} value={place._id}>
                { place.name }
              </option>
            ))
            }
          </select>
          <button onClick={addSelectedPlace}>Add to My Places</button>
        </div>
        {renderStatusEffect(status)}
        {requestSuccess && (
          <div>
            <p>Place added!</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default UserPlace;