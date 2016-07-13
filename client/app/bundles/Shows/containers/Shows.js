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
      editingShow: null,
      page: 1,
      shows: Immutable.List(),
      canSubmit: true
    }
    _.bindAll(this, 
      [
        '_updateShowsTable',
        '_handleDelete',
        '_handleUpdate',
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
          handleUpdate={this._handleUpdate}
          canSubmit={this.state.canSubmit}
        />
      </div>
    )
  }

  _updateShowsTable() {
    $.getJSON(`/api/shows.json?page=${this.state.page}`, (response) => {
      this.setState({
        shows: Immutable.fromJS(response),
        editingShow: null
      })
    })
  }

  _handleEdit(immutableShow) {
    this.setState({
      editingShow: immutableShow
    })
  }

  _handleUpdate(immutableShow) {
    this.setState({canSubmit: false})
    $.ajax({
      url: `/api/shows/${immutableShow.get('id')}`,
      type: 'PUT',
      data: {
        shows: immutableShow.toJS()
      },
      success: (response) => {
        this.setState({
          editingShow: null,
          canSubmit: true
        })
        this._updateShowsTable()
      }
    })
  }

  _handleDelete(id) {
    $.ajax({
      url: `/api/shows/${id}`,
      type: 'DELETE',
      success: (response) => {
        this._updateShowsTable(id)
      }
    })
  }
}
