'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import FunctionsHeader from './FunctionsHeader'
import FormRow from './FormRow'
import DatePagination from './DatePagination'

export default class FunctionsMain extends React.Component {
  static propTypes = {
    theater: PropTypes.object,
    formBuilders: PropTypes.array,
    loadingContent: PropTypes.boolean,
    offsetDays: PropTypes.number,
    onChangeOffsetDays: PropTypes.func,
  };

  render() {
    const theater = this.props.theater;
    const dateString = _.upperFirst(moment().add(this.props.offsetDays, 'days').format('dddd D [de] MMMM, YYYY'));
    return (
      <div>
        <FunctionsHeader title={theater.name} subtitle={dateString} />
        <DatePagination onChangeDay={this.props.onChangeOffsetDays} />
        {this._getFunctions()}
      </div>
    );
  }

  _getFunctions() {
    if (this.props.loadingContent) {
      return(<h1>Loading...</h1>);
    }
    else {
      return this.props.formBuilders.map((formBuilder) => {
        return(
          <FormRow formBuilder={formBuilder} />
        );
      });
    }
  }
}
