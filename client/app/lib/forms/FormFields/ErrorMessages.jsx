'use strict'

import React, {PropTypes} from 'react'
import _ from 'lodash'

import ListGroup from 'react-bootstrap/lib/ListGroup';
import ListGroupItem from 'react-bootstrap/lib/ListGroupItem';

export default class ErrorMessages extends React.Component {
  static propTypes = {
    errors: PropTypes.object
  };
  static defaultProps = {
    errors: {}
  };

  render() {
    if (_.isEmpty(this.props.errors)) {
      return null;
    }
    else {
      return (
        <ListGroup>
          {this._getErrors()}
        </ListGroup>
      );
    }
  }

  _getErrors() {
    let errorMessages = [];
    if (!_.isEmpty(this.props.errors)) {
      _.forIn(this.props.errors, (errorsArray, key) => {
        _.forEach(errorsArray, (msg) => {
          errorMessages.push(
            <ListGroupItem bsStyle="danger">
              <b>{key}</b>&nbsp;{msg}
            </ListGroupItem>
          );
        });
      });
    }
    return errorMessages;
  }
}