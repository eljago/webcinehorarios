'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import FunctionsMain from '../components/FunctionsMain'

import {FunctionsQueries} from '../../../lib/api/queries'

import FormBuilder from '../../../lib/forms/FormBuilder';
import GetFormSchema from '../data/FormSchema'

export default class Functions extends React.Component {

  static propTypes = {
    theater: PropTypes.object,
    default_function: PropTypes.object,
    function_types: PropTypes.array,
  };

  constructor(props) {
    super(props);

    moment.locale('es-CL');
    this.state = {
      formBuilders: [],
      offsetDays: 0,
      loadingContent: false
    }
    this.functionTypes = props.function_types.map((ft) => {
      return {value: ft.id, label: ft.name};
    });
    _.bindAll(this, '_updateFunctions');
  }

  componentDidMount() {
    this._updateFunctions();
  }

  render() {
    return(
      <FunctionsMain
        theater={this.props.theater}
        formBuilders={this.state.formBuilders}
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
      loadingContent: true,
      offsetDays: offsetDays
    });
    FunctionsQueries.getFunctions({
      date: date,
      theater_id: theater_id,
      success: (response) => {
        this.setState({
          formBuilders: response.shows.map((show) => {
            return(new FormBuilder(
              GetFormSchema({
                function_types: this.functionTypes,
                defaultFunction: this.props.default_function
              }),
              show
            ));
          }),
          loadingContent: false
        });
      },
      error: (errors) => {
        this.setState({
          loadingContent: false
        });
      }
    });
  }
}