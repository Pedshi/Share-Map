import mongoose from 'mongoose';

export default ( (uri: string) => {
  const connect = () => {
    mongoose.connect(uri, { 
      useNewUrlParser: true,
      useFindAndModify: false,
      useUnifiedTopology: true
    })
      .then( _ => { console.log('Connected succefully') } )
      .catch( error => { console.log(`Error connecting: ${error}`) });
  };
  
  connect();

  mongoose.connection.on('disconnected', connect)
});