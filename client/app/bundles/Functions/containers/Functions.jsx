'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import FunctionEdit from './FunctionEdit';

import FunctionsMain from '../components/FunctionsMain'
import EditFunctionsMain from '../components/EditFunctionsMain'
import DatePagination from '../components/DatePagination'
import FunctionsHeader from '../components/FunctionsHeader'

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'

import {FunctionsQueries, TheatersQueries} from '../../../lib/api/queries'

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
      errors: {},
      formBuilders: [],
      offsetDays: 0,
      loadingContent: false,
      editing: false,
      submittingShows: false,
      functionBeingEdited: null,
      editingFunction: false,
    }
    this.functionTypes = props.function_types.map((ft) => {
      return {value: ft.id, label: ft.name};
    });
    _.bindAll(this, [
      '_updateFunctions',
      '_onChangeEditing',
      '_onSubmitShows',
      '_onClickEditFunction',
      '_onStopEditingFunction',
    ]);
  }

  componentDidMount() {
    this._updateFunctions();
  }

  render() {
    const dateString = _.upperFirst(moment().add(this.state.offsetDays, 'days').format('dddd D [de] MMMM, YYYY'));
    return(
      <div>
        <ErrorMessages errors={this.state.errors} />
        <FunctionsHeader
          title={this.props.theater.name}
          subtitle={dateString}
          editing={this.state.editing}
          onChangeEditing={this._onChangeEditing}
        />
        <DatePagination onChangeDay={this._updateFunctions} offsetDays={this.state.offsetDays} />

        {(() => {
          if (this.state.loadingContent) {
            return <h1>Loading</h1>;
          }
          if (this.state.editing) {
            return(
              <EditFunctionsMain
                formBuilders={this.state.formBuilders}
                submittingShows={this.state.submittingShows}
                onSubmitShows={this._onSubmitShows}
                offsetDays={this.state.offsetDays}
                theaterId={this.props.theater.id}
                ref='form'
              />
            );
          }
          else {
            return(
              <div>
                <FunctionsMain
                  shows={this.state.formBuilders.map((fb) => {
                    return fb.object;
                  })}
                  functionTypes={this.functionTypes}
                  onClickEditFunction={this._onClickEditFunction}
                />
                <FunctionEdit
                  functionBeingEdited={this.state.functionBeingEdited}
                  editingFunction={this.state.editingFunction}
                  onStopEditingFunction={this._onStopEditingFunction}
                />
              </div>
            );
          }
        })()}
      </div>
    );
  }

  _onClickEditFunction(func) {
    this.setState({
      functionBeingEdited: func,
      editingFunction: true
    });
  }

  _onStopEditingFunction() {
    this.setState({editingFunction: false});
  }

  _onChangeEditing() {
    this.setState({editing: !this.state.editing});
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

  _onSubmitShows() {
    if (this.refs.form) {
      const functionsAttributes = this.refs.form.getResult();
      const theaterToSubmit = {
        id: this.props.theater.id,
        functions_attributes: functionsAttributes,
      };
      console.log(theaterToSubmit);

      this.setState({
        submittingShows: true,
      });
      TheatersQueries.submitEditTheater({
        theater: theaterToSubmit,
        success: (response) => {
          this.setState({
            submittingShows: false,
            editing: false
          });
          this._updateFunctions();
        },
        error: (errors) => {
          this.setState({
            errors: errors,
            submittingShows: false,
          });
        }
      });
    }
  }
}