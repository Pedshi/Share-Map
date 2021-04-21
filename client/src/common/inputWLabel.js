

function InputWLabel(props) {

  return (
    <div className="input-txt-with-label">
      <label>{props.labelText}*</label>
      <input type="text" 
        value={props.value} 
        onChange={e => props.onValueChange(e.target.value)}  required/>
    </div>
  );
}


export const renderStatusEffect = (status, errorMessage) => {
  const errMessage = errorMessage ? errorMessage: 'Unable to fulfill action';
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
          <p>{errMessage}</p>
        </div>
      );
    default:
      return (<div></div>);
  };
};


export default InputWLabel;

