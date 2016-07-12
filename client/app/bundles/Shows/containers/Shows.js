import React, { PropTypes } from 'react';
import _ from 'lodash';
import ShowsMain from '../components/ShowsMain';
import ShowModal from '../components/ShowModal';

export default class Shows extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      editingShow: null,
      page: 1,
      shows: []
    }
    _.bindAll(this, 
      [
        '_updateShowsTable',
        '_removeItemClient',
        '_handleDelete',
        '_handleSubmit',
        '_handleEdit'
      ]
    );
  }

  componentDidMount() {
    this._updateShowsTable();
  }

  render() {
    return (
      <div>
        <ShowsMain 
          shows={this.state.shows}
          handleEdit={this._handleEdit}
          handleDelete={this._handleDelete}
        />
        <ShowModal
          show={this.state.editingShow}
          handleSubmit={this._handleSubmit}
        />
      </div>
    );
  }

  _updateShowsTable() {
    $.getJSON(`/api/shows.json?page=${this.state.page}`, (response) => {
      this.setState({
        shows: response
      });
    });
  }

  _handleSubmit(show) {
    console.log(show);
    $.ajax({
      url: `/api/shows/${show.id}`,
      type: 'PUT',
      data: {
        shows: {
          name: show.name
        }
      },
      success: (response) => {
        this.setState({
          editingShow: null
        })
      }
    });
    this._updateShowsTable();
  }

  _handleEdit(show) {
    this.setState({
      editingShow: show
    });
  }

  _handleDelete(id) {
    $.ajax({
      url: `/api/shows/${id}`,
      type: 'DELETE',
      success: (response) => {
        this._removeShowClient(id);
      }
    });
  }

  _removeItemClient(id) {
    let newShows = this.state.shows.filter((show) => {
      return show.id != id;
    });
    this.setState({
      shows: newShows,
      editingShow: null,
    });
  }
}
