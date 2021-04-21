import { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { authReducerName, authenticateUser } from '../login/authSlice';
import  InputWLabel, { renderStatusEffect } from '../../common/inputWLabel';
import { createPlace, placeReducerName } from './placeSlice';
import { Redirect } from 'react-router-dom';

const categoryOptions = [
  {label: "Bar",        value: 1},
  {label: "Cafe",       value: 2},
  {label: "Restaurant", value: 3},
  {label: "Shop",       value: 4}
];

function Place() {

  const [placeName, setPlaceName] = useState('');
  const [address, setAddress] = useState('');
  const [latitude, setLatitude] = useState('');
  const [longitude, setLongitude] = useState('');
  const [igLocationUrl, setIgLocationUrl] = useState('');
  const [category, setCategory] = useState(1);
  const [openingHours, setOpeningHours] = useState({
    mon: '',
    tue: '',
    wed: '',
    thu: '',
    fri: '',
    sat: '',
    sun: ''
  });
  const { authenticated } = useSelector(state => state[authReducerName]);
  const { status, place } = useSelector(state => state[placeReducerName]);
  const dispatch = useDispatch();

  useEffect( () => {
    if (!authenticated)
      dispatch(authenticateUser());
  },[]);

  const updateOpeningHours = (name) => (value) => {
    setOpeningHours({
      ...openingHours,
      [name]: value
    });
  };

  const onSubmitHandler = (event) => {
    event.preventDefault();
    const place = {
      name: placeName,
      address,
      latitude,
      longitude,
      igLocationUrl,
      openingHours,
      category
    };
    dispatch(createPlace(place));
  };

  return (
    <div className="wrapper-admin">
      {!authenticated && (
          <Redirect to="/"/>
      )}
      <div className="form-container">
        <form onSubmit={onSubmitHandler}>
          <InputWLabel labelText="Name of Place" value={placeName}  onValueChange={setPlaceName}/>
          <br/>
          <InputWLabel labelText="Address" value={address} onValueChange={setAddress}/>
          <InputWLabel labelText="Latitude" value={latitude} onValueChange={setLatitude} />
          <InputWLabel labelText="Longitude" value={longitude} onValueChange={setLongitude} />
          <br/>
          <InputWLabel labelText="Instagram Location Tag Url" value={igLocationUrl} onValueChange={setIgLocationUrl} />
          <br/>
          <select onChange={e => setCategory(parseInt(e.target.value))}>
            {categoryOptions.map( (category) => (
                <option key={category.value} value={category.value}>
                  { category.label }
                </option>
              )
            )}
          </select>
          {Object.keys(openingHours).map( (key) => (
            <InputWLabel key={key} labelText={key} value={openingHours[key]} onValueChange={updateOpeningHours(key)} />
            ) 
          )}
          <br/>
          <input type="submit" value="Create Place"/>
        </form>
        { renderStatusEffect(status, 'Unable to save place!') }
        {place && (
          <div>
            <p>Succefully saved {placeName}</p>
          </div>
        )}
      </div>
    </div>
  );
}

export default Place;