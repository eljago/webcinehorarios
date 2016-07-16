import React, { PropTypes } from 'react'
import ReactDOM from 'react-dom'
import Immutable from 'immutable'
import _ from 'lodash'
import ShowsMain from '../components/ShowsMain'
import ShowModal from '../components/ShowModal'

export default class Shows extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      modalShow: this._getEmptyShow(),
      page: 1,
      shows: Immutable.List(),
    }
    _.bindAll(this, 
      [
        '_updateShowsTable',
        '_handleDelete',
        '_handleSubmit',
        '_handleEdit',
        '_openModal',
        '_closeModal',
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
          ref='modal'
          show={this.state.modalShow}
          handleSubmit={this._handleSubmit}
        />
      </div>
    )
  }

  _openModal() {
    this.refs.modal.open()
  }

  _closeModal() {
    this.refs.modal.close()
  }

  _updateShowsTable() {
    $.getJSON(`/api/shows.json?page=${this.state.page}`, (response) => {
      this.setState({
        shows: Immutable.fromJS(response)
      });
    });
  }

  _handleEdit(immutableShow) {
    this.setState({
      modalShow: immutableShow
    });
    this._openModal();
  }

  _handleSubmit(immutableShow) {
    $.ajax({
      url: `/api/shows/${immutableShow.get('id')}`,
      type: 'PUT',
      data: {
        shows: immutableShow.toJS()
      },
      success: (response) => {
        this._updateShowsTable();
        this._closeModal();
      }
    })
  }

  _handleDelete(id) {
    $.ajax({
      url: `/api/shows/${id}`,
      type: 'DELETE',
      success: (response) => {
        this._updateShowsTable(id);
      }
    })
  }

  _getEmptyShow() {
    return Immutable.fromJS({
      name: '',
      remote_image_url: '',
      image: ''
    });
  }
}
