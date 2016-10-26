'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Modal from 'react-bootstrap/lib/Modal';
import Button from 'react-bootstrap/lib/Button';

export default class FunctionEditModal extends React.Component {

  static propTypes = {
    functionBeingEdited: PropTypes.object,
    editingFunction: PropTypes.boolean,
    submitting: PropTypes.boolean,
    onSubmit: PropTypes.func,
    onStopEditing: PropTypes.func,
  };

  constructor(props) {
    super(props);
    _.bindAll(this, ['_stopEditing', '_handleSubmit']);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      editFunc: nextProps.editingFunction
    });
  }

  render() {
    const {functionBeingEdited, editingFunction, onSubmit, submitting} = this.props;
    return (
      <div>
        <Modal show={editingFunction} onHide={this._stopEditing}>
          <Modal.Header closeButton>
            <Modal.Title>Editar Función</Modal.Title>
          </Modal.Header>
          <Modal.Body>

          </Modal.Body>
          <Modal.Footer>
            <Button onClick={this._stopEditing}>Close</Button>
          </Modal.Footer>
        </Modal>
      </div>
    );
  }

  _stopEditing() {
    this.props.onStopEditing();
  }

  _handleSubmit() {
    this.props.onSubmit(this.state.editFunc);
  }
}