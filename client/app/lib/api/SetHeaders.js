'use strict'

//  ["31bfc005557fcccd2728d5710ce3f31f", "1b5bbddf9158bf194656e22d18703e96", "e4ab0b81ad763aec46e7408cbc897929"]

const API_VERSION = 1;
const TOKEN = 'e4ab0b81ad763aec46e7408cbc897929';

export default (xhr) => {
  xhr.setRequestHeader('Accept', 'application/json');
  xhr.setRequestHeader('Authorization', `Token token=${TOKEN}`);
  xhr.setRequestHeader('APIV', `application/cinehorarios.ios.v${API_VERSION}`);
};