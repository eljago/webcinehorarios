'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import Immutable from 'immutable'
import {
  Modal,
  Button,
  Form,
  Row,
  Col
} from 'react-bootstrap'

import {
  FormFieldText,
  FormFieldFile,
  FormFieldSelect,
  FormFieldDate,
  FormFieldRadioGroup,
  FormFieldCheckboxGroup,
} from '../../../lib/forms'

export default class ShowForm extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    handleSubmit: PropTypes.func.isRequired,
    genres: PropTypes.array
  };
  static defaultProps = {
    genres: []
  };

  constructor(props) {
    super(props)
    this.state = {
      showChanges: Immutable.Map(),
    }
    _.bindAll(this,
      [
        '_handleSubmit',
        '_onChange',
      ]  
    )
  }

  render() {
    const {show} = this.props;
    if (show) {
      const modalTitle = show ? show.get('name') : "Crear Show"

      return (
        <div className="container">
          <Form horizontal ref={'form'}>
            <Row>
              <Col md={8}>

                <FormFieldText
                  controlId='name'
                  label={'Nombre'}
                  initialValue={show.get('name')}
                  validations={[{name: 'notNull'}]}
                  onChange={this._onChange}
                />

                <Row>
                  <Col xs={12} md={7} lg={8}>
                    <FormFieldText
                      controlId='remote_image_url'
                      label={'Remote Image URL'}
                      initialValue={show.get('remote_image_url')}
                      onChange={this._onChange}
                    />
                  </Col>
                  <Col xs={12} md={4} mdOffset={1} lg={3} lgOffset={1}>
                    <FormFieldFile
                      controlId='image'
                      onChange={this._onChange}
                    />
                  </Col>
                </Row>

                <FormFieldText
                  type="textarea"
                  controlId='information'
                  label={'Synopsis'}
                  initialValue={show.get('information')}
                  onChange={this._onChange}
                />

                <Row>
                  <Col md={8} lg={9}>
                    <FormFieldText
                      controlId='imdb_code'
                      label={'Imdb Code'}
                      initialValue={show.get('imdb_code')}
                      onChange={this._onChange}
                    />
                  </Col>
                  <Col md={3} mdOffset={1} lg={2} lgOffset={1}>
                    <FormFieldText
                      type='number'
                      controlId='imdb_score'
                      label={'Imdb Score'}
                      initialValue={show.get('imdb_score')}
                      validations={[
                        {name: 'regExp', regExp: new RegExp("^([0-9]{2})$")}
                      ]}
                      onChange={this._onChange}
                    />
                  </Col>
                </Row>

                <Row>
                  <Col md={8} lg={9}>
                    <FormFieldText
                      controlId='metacritic_url'
                      label={'Metacritic URL'}
                      initialValue={show.get('metacritic_url')}
                      onChange={this._onChange}
                    />
                  </Col>
                  <Col md={3} mdOffset={1} lg={2} lgOffset={1}>
                    <FormFieldText
                      type='number'
                      controlId='metacritic_score'
                      label={'Metacritic Score'}
                      initialValue={show.get('metacritic_score')}
                      onChange={this._onChange}
                    />
                  </Col>
                </Row>

                <Row>
                  <Col md={8} lg={9}>
                    <FormFieldText
                      controlId='rotten_tomatoes_url'
                      label={'Rotten Tomatoes URL'}
                      initialValue={show.get('rotten_tomatoes_url')}
                      onChange={this._onChange}
                    />
                  </Col>
                  <Col md={3} mdOffset={1} lg={2} lgOffset={1}>
                    <FormFieldText
                      type='number'
                      controlId='rotten_tomatoes_score'
                      label={'Rotten Tomatoes Score'}
                      initialValue={show.get('rotten_tomatoes_score')}
                      onChange={this._onChange}
                    />
                  </Col>
                </Row>

              </Col>

              <Col md={3} mdOffset={1}>

                <FormFieldDate
                  controlId='debut'
                  label='Estreno'
                  onChange={this._onChange}
                  date={show.get('debut')}
                />

                <Row>
                  <Col xs={6} md={12}>
                    <FormFieldRadioGroup
                      controlId='rating'
                      label='Rating'
                      onChange={this._onChange}
                      options={[
                        {value: 'TE', label: 'TE'},
                        {value: 'TE+7', label: 'TE+7'},
                        {value: '14+', label: '14+'},
                        {value: '18+', label: '18+'},
                      ]}
                      selectedValue={show.get('rating')}
                    />
                  </Col>
                  <Col xs={6} md={12}>
                    <FormFieldCheckboxGroup
                      controlId='genre_ids'
                      label='Géneros'
                      onChange={this._onChange}
                      options={this.props.genres.map((genre) => {
                        return {value: genre.id, label: genre.name};
                      })}
                      selectedValues={show.get('genres').toJS().map((genre) => {
                        return genre.id;
                      })}
                    />
                  </Col>
                </Row>

              </Col>
            </Row>

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
    let valueToSet = value;

    if (_.isArray(valueToSet) && _.isEmpty(valueToSet)) {
      valueToSet = [" "];
    }

    const showChanges = this.state.showChanges.set(controlId, valueToSet);
    this.setState({showChanges});
    console.log(showChanges.toJS());
  }

  _handleSubmit() {
    let showChanges = this.state.showChanges;
    if (_.trim(showChanges.get('image')).length == 0) {
      showChanges = showChanges.delete('image');
    }
    if (_.trim(showChanges.get('remote_image_url')).length == 0) {
      showChanges = showChanges.delete('remote_image_url');
    }
    else {
      // don't send file image if remote_image_url is present
      showChanges = showChanges.delete('image');
    }
    this.props.handleSubmit(showChanges);
  }
}
