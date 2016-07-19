import React, { PropTypes } from 'react'
import _ from 'lodash'
import {
  Modal,
  Button,
  Form,
} from 'react-bootstrap'

import FormFieldText from '../../../lib/forms/FormFieldText'
import FormFieldFile from '../../../lib/forms/FormFieldFile'

export default class ShowForm extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    handleSubmit: PropTypes.func.isRequired,
  };

  constructor(props) {
    super(props)
    this.state = {
      currentShow: props.show,
    }
    _.bindAll(this,
      [
        '_handleSubmit',
        '_onChange',
      ]  
    )
  }

  componentWillReceiveProps(nextProps){
    this.state = {
      currentShow: nextProps.show,
    }
  }

  render() {
    const {show} = this.props;
    if (show) {
      const modalTitle = show ? show.get('name') : "Crear Show"

      return (
        <div className="container">
          <Form horizontal ref={'form'}>

            <FormFieldText
              controlId='name'
              label={'Nombre'}
              initialValue={show.get('name')}
              validations={['notNull']}
              onChange={this._onChange}
            />

            <FormFieldText
              controlId='remote_image_url'
              label={'Remote Image URL'}
              initialValue={show.get('remote_image_url')}
              onChange={this._onChange}
            />

            <FormFieldFile
              controlId='image'
              onChange={this._onChange}
            />

            <FormFieldText
              controlId='imdb_code'
              label={'Imdb Code'}
              initialValue={show.get('imdb_code')}
              onChange={this._onChange}
            />

            <FormFieldText
              type='number'
              controlId='imdb_score'
              label={'Imdb Score'}
              initialValue={show.get('imdb_score')}
              onChange={this._onChange}
            />

            <FormFieldText
              controlId='metacritic_url'
              label={'Metacritic URL'}
              initialValue={show.get('metacritic_url')}
              onChange={this._onChange}
            />

            <FormFieldText
              type='number'
              controlId='metacritic_score'
              label={'Metacritic Score'}
              initialValue={show.get('metacritic_score')}
              onChange={this._onChange}
            />

            <FormFieldText
              controlId='rotten_tomatoes_url'
              label={'Rotten Tomatoes URL'}
              initialValue={show.get('rotten_tomatoes_url')}
              onChange={this._onChange}
            />

            <FormFieldText
              type='number'
              controlId='rotten_tomatoes_score'
              label={'Rotten Tomatoes Score'}
              initialValue={show.get('rotten_tomatoes_score')}
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
        </div>
      );
    }
    else {
      return null;
    }
  }

  _onChange(controlId, value) {
    this.setState({
      currentShow: this.state.currentShow.set(controlId, value)
    });
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
