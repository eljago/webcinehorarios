'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import FunctionsMain from '../components/FunctionsMain'

import {FunctionsQueries} from '../../../lib/api/queries'

export default class Functions extends React.Component {

  static propTypes = {
    theater: PropTypes.object,
  };

  constructor(props) {
    super(props);

    moment.locale('es-CL');
    let today = moment();
    this.state = {
      functions: [],
      offsetDays: 0,
      loadingContent: false
    }
    _.bindAll(this, '_updateFunctions');
  }

  componentDidMount() {
    this._updateFunctions();
  }

  render() {
    return(
      <FunctionsMain
        theater={this.props.theater}
        functions={this.state.functions}
        loadingContent={this.state.loadingContent}
        offsetDays={this.state.offsetDays}
        onChangeOffsetDays={this._updateFunctions}
      />
    );
  }

  _updateFunctions(offsetDays = this.state.offsetDays) {
    const date = moment().add(offsetDays, 'days').format('YYYY-MM-DD');
    const theater_id = this.props.theater.id;
    this.setState({
      loadingContent: true
    });
    FunctionsQueries.getFunctions({
      date: date,
      theater_id: theater_id,
      success: (response) => {
        this.setState({
          functions: response.functions,
          loadingContent: false,
          offsetDays: offsetDays
        });
      },
      error: (errors) => {
        this.setState({
          loadingContent: false,
          offsetDays: offsetDays
        });
      }
    });
  }
}