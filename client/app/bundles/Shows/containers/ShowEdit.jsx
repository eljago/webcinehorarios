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
      />
    );
  }

  _handleSubmit(immutableShow) {
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

      }
    });
  }
}
