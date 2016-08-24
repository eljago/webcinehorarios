'use strict';

import React, { PropTypes } from 'react'

import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Image from 'react-bootstrap/lib/Image';

import FormFieldText from '../../../lib/forms/FormFields/FormFieldText'
import FormFieldImage from '../../../lib/forms/FormFields/FormFieldImage'
import FormFieldCheckbox from '../../../lib/forms/FormFields/FormFieldCheckbox'
import FormFieldDate from '../../../lib/forms/FormFields/FormFieldDate'
import FormFieldCheckboxGroup from '../../../lib/forms/FormFields/FormFieldCheckboxGroup'
import FormFieldRadioGroup from '../../../lib/forms/FormFields/FormFieldRadioGroup'


export default class ShowFormBasic extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    genres: PropTypes.array
  };

  constructor(props) {
    super(props);
    this.state = {
      thumbSource: ''
    }
    _.bindAll(this, '_handleImageChange');
  }

  render() {
    const show = this.props.show;
    const coverImage = show.image ? show.image.small.url : '';
    const showGenres = show.genres ? show.genres.map((value) => {
      return value.id;
    }) : [];

    return (
      <Row>
        <Col md={8}>
          <Row>
            <Col xs={12} md={3}>
              <Image src={this.state.thumbSource} responsive/>
            </Col>
            <Col xs={12} md={9}>
              <FormFieldText
                submitKey='name'
                label='Nombre'
                ref='name'
                initialValue={show.name}
              />
              <FormFieldText
                submitKey='name_original'
                label='Nombre Original'
                ref='name_original'
                initialValue={show.name_original}
              />
              <FormFieldText
                type='number'
                submitKey='year'
                label='Año'
                ref='year'
                initialValue={show.year}
              />
              <FormFieldText
                type='number'
                submitKey='duration'
                label='Duración'
                ref='duration'
                initialValue={show.duration}
              />
              <FormFieldImage
                onChange={this._handleImageChange}
                initialValue={coverImage}
                ref='image'
              />
            </Col>
          </Row>

          <FormFieldText
            type='textarea'
            submitKey='information'
            label='Sinopsis'
            ref='information'
            initialValue={show.information}
          />

          <Row>
            <Col md={8} lg={9}>
              <FormFieldText
                submitKey='imdb_code'
                label='IMDB Code'
                ref='imdb_code'
                initialValue={show.imdb_code}
              />
            </Col>
            <Col md={4} lg={3}>
              <FormFieldText
                type='number'
                submitKey='imdb_score'
                label='IMDB Score'
                ref='imdb_score'
                initialValue={show.imdb_score}
              />
            </Col>
          </Row>

          <Row>
            <Col md={8} lg={9}>
              <FormFieldText
                submitKey='metacritic_url'
                label='Metacritic URL'
                ref='metacritic_url'
                initialValue={show.metacritic_url}
              />
            </Col>
            <Col md={4} lg={3}>
              <FormFieldText
                type='number'
                submitKey='metacritic_score'
                label='Metacritic Score'
                ref='metacritic_score'
                initialValue={show.metacritic_score}
              />
            </Col>
          </Row>

          <Row>
            <Col md={8} lg={9}>
              <FormFieldText
                submitKey='rotten_tomatoes_url'
                label='Rotten Tomatoes URL'
                ref='rotten_tomatoes_url'
                initialValue={show.rotten_tomatoes_url}
              />
            </Col>
            <Col md={4} lg={3}>
              <FormFieldText
                type='number'
                submitKey='rotten_tomatoes_score'
                label='Rotten Tomatoes Score'
                ref='rotten_tomatoes_score'
                initialValue={show.rotten_tomatoes_score}
              />
            </Col>
          </Row>

        </Col>

        <Col md={4}>
          <FormFieldCheckbox
            submitKey='active'
            label='Activo'
            ref='active'
            initialValue={show.active}
          />
          <FormFieldDate
            submitKey='debut'
            label='Estreno'
            ref='debut'
            initialValue={show.debut}
          />

          <Row>
            <Col xs={3} md={12}>
              <FormFieldRadioGroup
                submitKey='rating'
                label='Calificación'
                ref='rating'
                options={[
                  {value: 'TE', label: 'TE'},
                  {value: 'TE+7', label: 'TE+7'},
                  {value: '14+', label: '14+'},
                  {value: '18+', label: '18+'},
                ]}
                initialValue={show.rating}
              />
            </Col>
            <Col xs={9} md={12}>
              <FormFieldCheckboxGroup
                submitKey='genre_ids'
                label='Géneros'
                ref='genres'
                options={this.props.genres.map((genre) => {
                  return {value: genre.id, label: genre.name};
                })}
                initialValue={showGenres}
              />
            </Col>
          </Row>

        </Col>
      </Row>
    );
  }

  _handleImageChange(thumbSource) {
    this.setState({thumbSource: thumbSource})
  }

  getResult() {
    let showResult = {};
    _.forIn(this.refs, (formElement) => {
      if (_.isFunction(formElement.getResult)) {
        _.merge(showResult, formElement.getResult());
      }
    });
    return showResult;
  }
}
