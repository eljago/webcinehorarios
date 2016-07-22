'use strict';

import React, { PropTypes } from 'react'
import {
  Row,
  Col
} from 'react-bootstrap'

import {
  FormFieldText,
  FormFieldFile,
  FormFieldDate,
  FormFieldRadioGroup,
  FormFieldCheckboxGroup,
} from '../../../lib/forms'

export default class ShowFormBasic extends React.Component {
  static propTypes = {
    show: PropTypes.object,
    onChange: PropTypes.func,
    genres: PropTypes.array,
  };
  static defaultProps = {
    genres: []
  };

  render() {
    const {show} = this.props;
    if (show) {
      const {onChange, genres} = this.props;
      const modalTitle = show ? show.get('name') : "Crear Show"

      return (
        <Row>
          <Col md={8}>

            <FormFieldText
              controlId='name'
              label={'Nombre'}
              initialValue={show.get('name')}
              regExp={new RegExp("^\\b.+\\b$")}
              validations={[{name: 'notNull'}]}
              onChange={onChange}
            />

            <Row>
              <Col xs={12} md={7} lg={8}>
                <FormFieldText
                  controlId='remote_image_url'
                  label={'Remote Image URL'}
                  initialValue={show.get('remote_image_url')}
                  onChange={onChange}
                />
              </Col>
              <Col xs={12} md={4} mdOffset={1} lg={3} lgOffset={1}>
                <FormFieldFile
                  controlId='image'
                  onChange={onChange}
                />
              </Col>
            </Row>

            <FormFieldText
              type="textarea"
              controlId='information'
              label={'Synopsis'}
              initialValue={show.get('information')}
              onChange={onChange}
            />

            <Row>
              <Col md={8} lg={9}>
                <FormFieldText
                  controlId='imdb_code'
                  label={'Imdb Code'}
                  initialValue={show.get('imdb_code')}
                  onChange={onChange}
                  regExp={new RegExp("^t{2}\\d{7}$")}
                />
              </Col>
              <Col md={3} mdOffset={1} lg={2} lgOffset={1}>
                <FormFieldText
                  type='number'
                  controlId='imdb_score'
                  label={'Imdb Score'}
                  initialValue={show.get('imdb_score')}
                  regExp={new RegExp("^([0-9]{2})$")}
                  onChange={onChange}
                />
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                <FormFieldText
                  controlId='metacritic_url'
                  label={'Metacritic URL'}
                  initialValue={show.get('metacritic_url')}
                  onChange={onChange}
                  regExp={new RegExp("^http://www.metacritic.com/movie/[\\w-]+/?$")}
                />
              </Col>
              <Col md={3} mdOffset={1} lg={2} lgOffset={1}>
                <FormFieldText
                  type='number'
                  controlId='metacritic_score'
                  label={'Metacritic Score'}
                  initialValue={show.get('metacritic_score')}
                  regExp={new RegExp("^([0-9]{2})$")}
                  onChange={onChange}
                />
              </Col>
            </Row>

            <Row>
              <Col md={8} lg={9}>
                <FormFieldText
                  controlId='rotten_tomatoes_url'
                  label={'Rotten Tomatoes URL'}
                  initialValue={show.get('rotten_tomatoes_url')}
                  onChange={onChange}
                  regExp={new RegExp("^https://www.rottentomatoes.com/m/[\\w-]+/?$")}
                />
              </Col>
              <Col md={3} mdOffset={1} lg={2} lgOffset={1}>
                <FormFieldText
                  type='number'
                  controlId='rotten_tomatoes_score'
                  label={'Rotten Tomatoes Score'}
                  initialValue={show.get('rotten_tomatoes_score')}
                  regExp={new RegExp("^([0-9]{2})$")}
                  onChange={onChange}
                />
              </Col>
            </Row>

          </Col>

          <Col md={3} mdOffset={1}>

            <FormFieldDate
              controlId='debut'
              label='Estreno'
              onChange={onChange}
              date={show.get('debut')}
            />

            <Row>
              <Col xs={6} md={12}>
                <FormFieldRadioGroup
                  controlId='rating'
                  label='Rating'
                  onChange={onChange}
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
                  onChange={onChange}
                  columns={2}
                  options={genres.map((genre) => {
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
      );
    }
    else {
      return null;
    }
  }
}
