'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import PeopleMain from '../components/PeopleMain'
import PeopleEdit from './PeopleEdit'

import {PeopleQueries} from '../../../lib/api/queries'

import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

export default class People extends React.Component {

  static propTypes = {
    defaultPerson: PropTypes.object,
  };

  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      itemsPerPage: 30,
      people: [],
      pagesCount: null,
      currentSearch: '',
    };
    _.bindAll(this, [
      '_updateData',
      '_onChangePage',
      '_onSearch',
      '_onEditPerson',
    ]);
  }

  componentDidMount() {
    this._updateData();
  }

  render() {
    return (
      <Grid>
        <Row>
          <Col sm={7}>
            <PeopleMain
              page={this.state.page}
              itemsPerPage={this.state.itemsPerPage}
              people={this.state.people}
              pagesCount={this.state.pagesCount}
              onChangePage={this._onChangePage}
              onSearchPerson={this._onSearch}
              onEditPerson={this._onEditPerson}
            />
          </Col>
          <Col sm={5}>
            <PeopleEdit
              ref='peopleEdit'
              defaultPerson={this.props.defaultPerson}
              onSuccess={() => this._updateData()}
            />
          </Col>
        </Row>
      </Grid>
    );
  }

  _onEditPerson(person) {
    this.refs.peopleEdit.editPerson(person);
  }

  _updateData(newPage = this.state.page, searchValue = this.state.currentSearch) {
    PeopleQueries.getPeople({
      page: newPage,
      perPage: this.state.itemsPerPage,
      searchValue: searchValue,
      success: (response) => {
        this.setState({
          page: newPage,
          people: response.people.map((person) => {
            return {
              id: person.id,
              name: person.name,
              imdb_code: person.imdb_code,
              image: person.image
            }
          }),
          pagesCount: response.count,
          currentSearch: searchValue,
        });
      }
    });
  }

  _onChangePage(newPage) {
    this._updateData(newPage);
  }

  _onSearch(searchValue) {
    this._updateData(1, searchValue);
  }
}
