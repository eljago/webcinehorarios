import React from 'react';
import ShowsContainer from '../containers/Shows';
import ShowEditContainer from '../containers/ShowEdit';

export const Shows = (props) => (
  <ShowsContainer {...props} />
)

export const ShowEdit = (props) => (
  <ShowEditContainer {...props} />
)