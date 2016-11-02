'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'
import update from 'react/lib/update';

import FunctionEdit from './FunctionEdit';

import FunctionsMain from '../components/FunctionsMain'
import EditFunctionsMain from '../components/EditFunctionsMain'
import DatePagination from '../components/DatePagination'
import FunctionsHeader from '../components/FunctionsHeader'
import AddShow from '../components/AddShow'

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
      loadingMessage: 'Loading',
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
      '_onCopyDay',
      '_onDeleteDay',
      '_onDeleteOnward',
      '_onShowAdded',
    ]);
  }

  componentDidMount() {
    this._updateFunctions();
  }

  render() {
    return(
      <div>
        <ErrorMessages errors={this.state.errors} />
        <FunctionsHeader
          title={this.props.theater.name}
          subtitle={_.upperFirst(moment().add(this.state.offsetDays, 'days').format('dddd D [de] MMMM, YYYY'))}
          editing={this.state.editing}
          onChangeEditing={this._onChangeEditing}
          onCopyDay={this._onCopyDay}
          onDeleteDay={this._onDeleteDay}
          onDeleteOnward={this._onDeleteOnward}
          disabled={this.state.loadingContent || this.state.submittingShows}
        />
        <DatePagination
          onChangeDay={this._updateFunctions}
          offsetDays={this.state.offsetDays}
          disabled={this.state.loadingContent || this.state.submittingShows}
        />

        {(() => {
          if (this.state.loadingContent) {
            return <h1>{this.state.loadingMessage}</h1>;
          }
          if (this.state.editing) {
            return(
              <div>
                <AddShow
                  onShowAdded={this._onShowAdded}
                  disabled={this.state.loadingContent || this.state.submittingShows}
                />
                <EditFunctionsMain
                  formBuilders={this.state.formBuilders}
                  submittingShows={this.state.submittingShows}
                  onSubmitShows={this._onSubmitShows}
                  offsetDays={this.state.offsetDays}
                  ref='form'
                />
              </div>
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

  _getDateString(offsetDays = this.state.offsetDays) {
    return moment().add(offsetDays, 'days').format('YYYY-MM-DD');
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

  _onShowAdded(newShow) {
    if (newShow) {
      console.log(newShow);
      for (const formBuilder of this.state.formBuilders) {
        const show = formBuilder.object;
        if (newShow.id == newShow.value) {
          return; // Show already added
        }
      }
      const show = {
        id: newShow.value,
        name: newShow.label,
        image_url: newShow.image_url,
      }
      const newFormBuilder = new FormBuilder(
        GetFormSchema({
          function_types: this.functionTypes,
          defaultFunction: this.props.default_function,
        }),
        show
      );
      this.setState({
        formBuilders: update(this.state.formBuilders, {$push: [newFormBuilder]})
      });
    }
  }

  // HEADER ACTIONS

  _onCopyDay() {
    if (confirm("¿Copiar día?")) {
      this.setState({
        loadingContent: true,
        loadingMessage: 'Copiando Día',
      });
      FunctionsQueries.copyDay({
        theaterId: this.props.theater.id,
        date: this._getDateString(),
        success: (response) => {
          this._updateFunctions(this.state.offsetDays + 1);
        },
        error: (errors) => {
          this.setState({
            errors: errors,
            loadingContent: false,
          });
        }
      });
    }
  }

  _onDeleteDay() {
    if (confirm("Borrar día?")) {
      this.setState({
        loadingContent: true,
        loadingMessage: 'Borrando Día',
      });
      FunctionsQueries.deleteDay({
        theaterId: this.props.theater.id,
        date: this._getDateString(),
        success: (response) => {
          this._updateFunctions();
        },
        error: (errors) => {
          this.setState({
            errors: errors,
            loadingContent: false,
          });
        }
      });
    }
  }

  _onDeleteOnward() {
    if (confirm("Borrar desde hoy?")) {
      this.setState({
        loadingContent: true,
        loadingMessage: 'Borrando desde hoy',
      });
      FunctionsQueries.deleteOnward({
        theaterId: this.props.theater.id,
        date: this._getDateString(),
        success: (response) => {
          this._updateFunctions();
        },
        error: (errors) => {
          this.setState({
            errors: errors,
            loadingContent: false,
          });
        }
      });
    }
  }

  _updateFunctions(offsetDays = this.state.offsetDays) {
    this.setState({
      loadingContent: true,
      offsetDays: offsetDays
    });
    FunctionsQueries.getFunctions({
      theaterId: this.props.theater.id,
      date: this._getDateString(offsetDays),
      success: (response) => {
        if (offsetDays == this.state.offsetDays) {
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
            loadingContent: false,
            errors: {},
          });
        }
      },
      error: (errors) => {
        this.setState({
          errors: errors,
          loadingContent: false
        });
      }
    });
  }

  _onSubmitShows() {
    if (this.refs.form) {
      const theaterToSubmit = {
        id: this.props.theater.id,
        functions_attributes: this.refs.form.getResult(),
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