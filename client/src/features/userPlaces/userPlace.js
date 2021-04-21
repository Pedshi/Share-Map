import { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import { renderStatusEffect } from '../../common/inputWLabel';
import { placeReducerName, fetchAllPlaces } from '../createPlace/placeSlice';
import { addPlace, userReducerName } from '../login/userSlice';

function UserPlace() {

  const [selectedPlace, setSelectedPlace] = useState(null);
  const { places, status } = useSelector( state => state[placeReducerName] );
  const { requestSuccess } = useSelector( state => state[userReducerName] );
  const dispatch = useDispatch();
  useEffect( () => {
    dispatch(fetchAllPlaces());
  },[]);

  const addSelectedPlace = () => {
    if (selectedPlace)
      dispatch(addPlace(selectedPlace));
  };
  
  return (
    <div className="wrapper">
      <div className="form-container">
          <select onChange={ (e) => setSelectedPlace(e.target.value) }>
            { places.map( (place) => (
              <option key={place._id} value={place._id}>
                { place.name }
              </option>
            ))
            }
          </select>
          <button onClick={addSelectedPlace}>Add to My Places</button>
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