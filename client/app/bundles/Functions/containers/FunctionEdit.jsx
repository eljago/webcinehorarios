'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import FunctionEditModal from '../components/FunctionEditModal'

export default class FunctionEdit extends React.Component {

  static propTypes = {
    functionBeingEdited: PropTypes.object,
    editingFunction: PropTypes.boolean,
    onStopEditingFunction: PropTypes.func
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false,
    }
    _.bindAll(this, ['_handleSubmit', '_stopEditing']);
  }

  render() {
    return (
      <div>
        <FunctionEditModal
          functionBeingEdited={this.props.functionBeingEdited}
          submitting={this.state.submitting}
          onSubmit={this._handleSubmit}
          editingFunction={this.props.editingFunction}
          onStopEditing={this._stopEditing}
        />
      </div>
    );
  }

  _stopEditing() {
    this.props.onStopEditingFunction();
  }

  _handleSubmit() {

  }
}