'use strict'

//  ["31bfc005557fcccd2728d5710ce3f31f", "1b5bbddf9158bf194656e22d18703e96", "e4ab0b81ad763aec46e7408cbc897929"]

const API_VERSION = 1;
const TOKEN = 'e4ab0b81ad763aec46e7408cbc897929';

const SetHeaders = (xhr) => {
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.setRequestHeader('Authorization', `Token token=${TOKEN}`);
  xhr.setRequestHeader('APIV', `application/cinehorarios.ios.v${API_VERSION}`);
};

const MyErrorCallback = (response, errorCallback) => {
  console.log("ERROR CALLBACK");
  console.log(response);
  let MyErrors = {};
  if (response.status === 400) {
    _.merge(MyErrors, {"400": ['Bad Request']});
  }
  else if (response.status === 404) {
    _.merge(MyErrors, {"404": ['Not Found']});
  }
  else if (response.status === 500) {
    _.merge(MyErrors, {"500": ['Error']});
  }

  if (response.responseJSON) {
    console.log(response.responseJSON.errors);
    _.merge(MyErrors, response.responseJSON.errors);
  }
  errorCallback(MyErrors);
};

export default (options) => {
  return({
    url: options.url,
    type: options.type,
    dataType: 'json',
    success: options.success,
    error: (response) => { MyErrorCallback(response, options.error) },
    beforeSend: SetHeaders,
    data: options.data
  });
};