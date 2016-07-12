import React, { PropTypes } from 'react';
import _ from 'lodash';
import {Modal, Button, Form, FormControl, ControlLabel, FormGroup} from 'react-bootstrap'

// Simple example of a React "smart" component
export default class ShowModal extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    handleSubmit: PropTypes.func.isRequired
  };

  constructor(props) {
    super(props)
    this.state = {
      show: props.show
    }
    _.bindAll(this, '_handleSubmit', '_close', '_handleChange')
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      show: nextProps.show
    })
  }

  render() {
    const show = this.state.show
    const modalVisible = show != null
    const modalTitle = this.props.show ? this.props.show.get('name') : "Crear Show"
    return (
      <Modal show={modalVisible} onHide={this._close}>
        <Modal.Header closeButton>
          <Modal.Title>{modalTitle}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form horizontal>
            <FormGroup controlId="formShowName">
              <ControlLabel>Nombre</ControlLabel>
              <FormControl
                type="text"
                value={show ? show.get('name') : ''}
                placeholder="Nombre"
                onChange={this._handleChange}
              />
            </FormGroup>
          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this._handleSubmit}>Submit</Button>
          <Button onClick={this._close}>Close</Button>
        </Modal.Footer>
      </Modal>
    );
  }

  _handleChange(e) {
    const formControl = e.target;
    let show = this.state.show;
    if (formControl.id === 'formShowName') {
      show = show.set('name', e.target.value)
    }

    this.setState({
      show: show
    })
  }

  _close() {
    this.setState({
      show: null
    })
  }

  _handleSubmit() {
    this.props.handleSubmit(this.state.show);
  }
}
