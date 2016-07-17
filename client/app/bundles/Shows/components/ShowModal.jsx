import React, { PropTypes } from 'react'
import _ from 'lodash'
import {
  Modal,
  Button,
  Form,
} from 'react-bootstrap'
import Immutable from 'immutable';

import FormFieldText from '../../../lib/forms/FormFieldText'
import FormFieldFile from '../../../lib/forms/FormFieldFile'

export default class ShowModal extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    handleSubmit: PropTypes.func.isRequired,
  };

  constructor(props) {
    super(props)
    this.state = {
      currentShow: props.show,
      visible: false,
    }
    _.bindAll(this,
      '_handleSubmit',
      '_onChange',
      'close',
      'open',
    )
  }

  componentWillReceiveProps(nextProps){
    this.state = {
      currentShow: nextProps.show,
    }
  }

  render() {
    const modalTitle = this.props.show ? this.props.show.get('name') : "Crear Show"

    return (
      <Modal show={this.state.visible} onHide={this.close}>
        <Modal.Header closeButton>
          <Modal.Title>{modalTitle}</Modal.Title>
        </Modal.Header>

        <Modal.Body>
          <Form horizontal ref={'form'}>

            <FormFieldText
              controlId='name'
              label={'Nombre'}
              initialValue={this.props.show.get('name')}
              validations={['notNull']}
              onChange={this._onChange}
            />

            <FormFieldText
              controlId='remote_image_url'
              label={'Remote Image URL'}
              initialValue={this.props.show.get('remote_image_url')}
              onChange={this._onChange}
            />

            <FormFieldFile
              controlId='image'
              onChange={this._onChange}
            />

            <FormFieldText
              controlId='imdb_code'
              label={'Imdb Code'}
              initialValue={this.props.show.get('imdb_code')}
              onChange={this._onChange}
            />

            <Button
              onClick={this._handleSubmit}
              target
              disabled={false}
              type="submit"
            >
              Submit
            </Button>

          </Form>
        </Modal.Body>

        <Modal.Footer>
          <Button onClick={this.close}>Close</Button>
        </Modal.Footer>
      </Modal>
    );
  }

  open() {
    this.setState({visible: true})
  }

  close() {
    this.setState({visible: false})
  }

  _onChange(controlId, value) {
    this.setState({
      currentShow: this.state.currentShow.set(controlId, value)
    })
  }

  _handleSubmit() {
    let showToSubmit = this.state.currentShow;
    if (_.trim(showToSubmit.get('image')).length == 0) {
      showToSubmit = showToSubmit.delete('image');
    }
    if (_.trim(showToSubmit.get('remote_image_url')).length == 0) {
      showToSubmit = showToSubmit.delete('remote_image_url');
    }
    else {
      // don't send file image if remote_image_url is present
      showToSubmit = showToSubmit.delete('image');
    }
    this.props.handleSubmit(showToSubmit);
  }


}
