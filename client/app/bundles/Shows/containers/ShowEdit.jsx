'use strict';

import React, { PropTypes } from 'react'
import Immutable from 'immutable'
import _ from 'lodash'
import ShowForm from '../components/ShowForm'

export default class ShowEdit extends React.Component {
  static propTypes = {
    show: PropTypes.object
  };

  constructor(props) {
    super(props);
    this.state = {
      show: Immutable.fromJS(props.show),
      canSubmit: true,
    };
    _.bindAll(this,
      [
        '_handleSubmit',
      ]
    );
  }

  render() {
    return (
      <ShowForm
        show={this.state.show}
        handleSubmit={this._handleSubmit}
        genres={this.props.genres}
        canSubmit={this.state.canSubmit}
      />
    );
  }

  _handleSubmit(immutableShow) {
    this.setState({canSubmit: false});
    $.ajax({
      url: `/api/shows/${this.props.show.id}`,
      type: 'PUT',
      data: {
        shows: {
          id: this.props.show.id,
          ...immutableShow.toJS()
        }
      },
      success: (response) => {
        window.location.replace('/admin/shows');
      }
    });
  }
}
