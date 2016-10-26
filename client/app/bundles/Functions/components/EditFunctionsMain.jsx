'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import EditShowRow from './EditShowRow'

export default class EditFunctionsMain extends React.Component {
  static propTypes = {
    formBuilders: PropTypes.array,
    loadingContent: PropTypes.boolean,
    submittingShows: PropTypes.boolean,
    onSubmitShows: PropTypes.func,
    dateFormatted: PropTypes.string,
    theaterId: PropTypes.number,
  };

  constructor(props) {
    super(props);
    _.bindAll(this, '_onSubmit');
  }

  render() {
    if (this.props.loadingContent) {
      return (<h1>Loading...</h1>);
    }
    else {
      return (
        <form>
          <table className="table table-striped">
            <tbody>
              {this._getFunctions()}
            </tbody>
          </table>
          <button
            className={`btn btn-primary`}
            type='submit'
            disabled={this.props.submittingShows}
            onClick={this._onSubmit}
          >
            Submit
          </button>
        </form>
      );
    }
  }

  _onSubmit(e) {
    this.props.onSubmitShows();
    e.preventDefault();
  }

  _getFunctions() {
    return this.props.formBuilders.map((formBuilder) => {
      return(
        <EditShowRow
          key={formBuilder.object.id}
          ref={`show_${formBuilder.object.id}`}
          formBuilder={formBuilder}
          dateFormatted={this.props.dateFormatted}
          theaterId={this.props.theaterId}
        />
      );
    });
  }

  getResult() {
    let showsResult = {};
    for (const formBuilder of this.props.formBuilders) {
      const show = formBuilder.object;
      const ref = `show_${show.id}`;
      const formElement = this.refs[ref];
      if (formElement && _.isFunction(formElement.getResult)) {
        showsResult[show.id] = formElement.getResult();
      }
    }
    return showsResult;
  }
}
