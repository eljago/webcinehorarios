import React, { PropTypes } from 'react'
import _ from 'lodash'
import {
  Modal,
  Button,
  Form,
  FormControl,
  ControlLabel,
  FormGroup,
  HelpBlock
} from 'react-bootstrap'
import Immutable from 'immutable';

import FormFieldText from '../../../lib/forms/FormFieldText'

export default class ShowModal extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    handleSubmit: PropTypes.func.isRequired,
    canSubmit: PropTypes.boolean
  };

  constructor(props) {
    super(props)
    this.state = {
      show: props.show
    }
    _.bindAll(this,
      '_handleSubmit',
      '_close',
      '_onChange',
    )
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      show: nextProps.show
    })
  }

  render() {
    const modalTitle = this.props.show ? this.props.show.get('name') : "Crear Show"
    const show = this.state.show
    return (
      <Modal show={show != null} onHide={this._close}>
        <Modal.Header closeButton>
          <Modal.Title>{modalTitle}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form horizontal ref={'form'}>

            <FormFieldText
              controlId='name'
              label={'Nombre'}
              initialValue={show ? show.get('name') : ''}
              validations={['notNull']}
              onChange={this._onChange}
            />

            <FormFieldText
              controlId='remote_image_url'
              label={'Remote Image URL'}
              onChange={this._onChange}
            />

            <Button
              onClick={this._handleSubmit}
              target
              disabled={!(this.props.canSubmit)}
              type="submit"
            >
              Submit
            </Button>

          </Form>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={this._close}>Close</Button>
        </Modal.Footer>
      </Modal>
    );
  }

  _onChange(controlId, value) {
    this.setState({
      show: this.state.show.set(controlId, value)
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
